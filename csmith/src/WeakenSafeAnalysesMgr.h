#ifndef WEAKEN_SAFE_ANALYSES_MANAGER_H
#define WEAKEN_SAFE_ANALYSES_MANAGER_H

#include <vector>
#include <set>
#include <string>
#include <boost/random.hpp>
#include "CommonMacros.h"

using namespace std;
using namespace boost::random;

class Variable;
class FunctionInvocation;

#define DEFAULT_PROB 0.2
#define MAX_LOC 7
#define MAX_OP 5

//#define WA_RRS_DEBUG    // On for prints of effected by WA code

const boost::uniform_int<> zero_to_urange( 0, MAX_OP ); // eAdd, eSub, eMul,eDiv,eMod : rnd 0-4

/*
    RRS - tested dynamically (working: safe_math)
    WA - tested with sanitizers (working *,1)
        ADD WA: if (WeakenSafeAnalysesMgr::GetInstance()->rnd_weaken_analysis_i(1)) { }

    * - PA of null and dangling pointers in return values and assignement via csmith flags for static analysers testing
    TODO: 0 - wrap as deadcode relaxed unsafe code (any of the rest of the options if STATEMENT==BLOCK)
    1 - (EA) allow (sometimes) a write to a variable that is being read/write partially (not allowing R/R) 
    2 - Allow use of variables without init (taken in low probablity)
    3 - (PA) call to a function: parmeters can take the address of an argument (should be with some low prob. else we have performance issues)
    4 - Out of bound access in arrays (done after post-gen, during output, ArrayVariable, take in small probablity)
    5 - Allow use of variables without init - goto skips defitions
    6 - Out of bound access in arrays with complex expression
*/

class WeakenSafeAnalysesMgr
{
public:
    static void CreateInstance(const unsigned long seed, const std::string probs_file);
    static WeakenSafeAnalysesMgr *GetInstance();

    // v -> if we manipolate it, skips asserts related to it
    virtual bool is_weaken_analysis_affected_var(const Variable *var) const;
    virtual void weaken_analysis_add_affected_var(const Variable *var);
    virtual bool is_weaken_analysis_affected_funcs(const FunctionInvocation *funcs) const;
    virtual void weaken_analysis_add_affected_funcs(const FunctionInvocation *funcs);
    virtual bool is_weaken_analysis_affected_stmt(const int stmt) const;
    virtual void weaken_analysis_add_affected_stmt(const int stmt);

    // i -> unique location of each safe analysis to weaken
	virtual bool rnd_weaken_analysis_i(const unsigned int i);
    virtual bool rnd_wrp_as_deadcode();
    unsigned rnd_weaken_analysis_i_op(const unsigned int i);

    // RRS
    virtual std::string annotate_arith_code_wrapper() const;

	virtual ~WeakenSafeAnalysesMgr(void);

protected:

    virtual void initialize_probs(const std::string probs_file);

private:
    const unsigned long seed_;

    std::vector<double> probs_;

    std::set<const Variable*> vars_affected_;
    std::set<const FunctionInvocation*> funcs_affected_;
    std::set<int> stmt_id_affected_;

    boost::random::mt19937 rng_; // uniform_01

    boost::variate_generator<  boost::mt19937, boost::uniform_int<> > dice_generator_;

    uniform_01<mt19937> dist_;

    const bool seed_as_main_generator_;

    static WeakenSafeAnalysesMgr *instance_; 

    // seed 0 -> use RandomNumber; probs_file empty -> 0.2 flat
    explicit WeakenSafeAnalysesMgr(const unsigned long seed, const std::string probs_file);

    // Don't implement them
    DISALLOW_COPY_AND_ASSIGN(WeakenSafeAnalysesMgr);
};

#endif