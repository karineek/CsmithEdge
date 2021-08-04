#include "WeakenSafeAnalysesMgr.h"
#include "CGOptions.h"
#include "random.h"
#include "Variable.h"
#include "FunctionInvocation.h"

#include <fstream>
#include <cassert>

WeakenSafeAnalysesMgr *WeakenSafeAnalysesMgr::instance_ = NULL;

WeakenSafeAnalysesMgr::WeakenSafeAnalysesMgr(const unsigned long seed, const std::string probs_file)
	: seed_(seed), probs_(MAX_LOC, DEFAULT_PROB), 
      rng_(seed), dice_generator_(rng_, zero_to_urange), dist_(rng_), 
      seed_as_main_generator_(seed_==0)
{
    if (CGOptions::enable_relax_anlayses_conditions())
        initialize_probs(probs_file);
}

WeakenSafeAnalysesMgr::~WeakenSafeAnalysesMgr()
{
    if (CGOptions::enable_relax_anlayses_conditions()) {
        std::ofstream probs_out("probs_WeakenSafeAnalyse.txt");
        for (const auto &e : probs_) probs_out << e << "\n";
        probs_out.close();
    }
}

void
WeakenSafeAnalysesMgr::CreateInstance(const unsigned long seed, const std::string probs_file)
{
	assert(!instance_);
    instance_ = new WeakenSafeAnalysesMgr(seed, probs_file);
}

WeakenSafeAnalysesMgr*
WeakenSafeAnalysesMgr::GetInstance(void)
{
	assert(instance_);
	return instance_;
}

bool 
WeakenSafeAnalysesMgr::is_weaken_analysis_affected_var(const Variable *var) const
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return false;
    if (!var) return false;
    return (vars_affected_.count(var) > 0);
}

void 
WeakenSafeAnalysesMgr::weaken_analysis_add_affected_var(const Variable *var)
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return;
    if (!var) return;
    if (vars_affected_.count(var) > 0) return;   

    vars_affected_.emplace(var);
}

bool 
WeakenSafeAnalysesMgr::is_weaken_analysis_affected_funcs(const FunctionInvocation *funcs) const
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return false;
    if (!funcs) return false;
    return (funcs_affected_.count(funcs) > 0);
}

void 
WeakenSafeAnalysesMgr::weaken_analysis_add_affected_funcs(const FunctionInvocation *funcs)
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return;
    if (!funcs) return;
    if (funcs_affected_.count(funcs) > 0) return;   

    funcs_affected_.emplace(funcs);
}

bool 
WeakenSafeAnalysesMgr::is_weaken_analysis_affected_stmt(const int stmt) const
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return false;
    if (!stmt) return false;
    return (stmt_id_affected_.count(stmt) > 0);
}

void 
WeakenSafeAnalysesMgr::weaken_analysis_add_affected_stmt(const int stmt)
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return;
    if (!stmt) return;
    if (stmt_id_affected_.count(stmt) > 0) return;   

    stmt_id_affected_.emplace(stmt);
}

void 
WeakenSafeAnalysesMgr::initialize_probs(const std::string probs_file)
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return;
    if (probs_file.empty()) return;

    std::ifstream probs_in(probs_file);
    if (!probs_in.fail()) {
        for (int i=0; i < MAX_LOC; i++) {
            std::string prob_str="";
            if (!std::getline(probs_in, prob_str)) 
                break;
            probs_[i] = atof(prob_str.c_str());
        }
    }
    probs_in.close();
}

bool 
WeakenSafeAnalysesMgr::rnd_weaken_analysis_i(const unsigned int i)
{
    if (!CGOptions::enable_relax_anlayses_conditions()) return false;
    double cut_prob = (probs_.size() < i ? DEFAULT_PROB : probs_[i]);
    if (cut_prob == 0.0) return false;

    bool res=true;
    if (seed_as_main_generator_) {
	    double curr_p = 100. * cut_prob;
        res=rnd_flipcoin((int)curr_p, 0, 0); // trunk curr_p, used: (genrand() % 100) < p
    } else { 
        double data=dist_(); 
        res=(data < cut_prob);
        //cout << "/* DiceX: " << res << ", " << data <<  "*/\n"; /* Avoid some strange bug */
    } 
    return res;
}

unsigned 
WeakenSafeAnalysesMgr::rnd_weaken_analysis_i_op(const unsigned int i)
{   
    if (!CGOptions::enable_relax_anlayses_conditions()) return 0;
    if (i!=6) return 0; // Which options needs this functionality
    if (MAX_OP < 2) return 0;

    unsigned res=0;
    if (seed_as_main_generator_) {  
        res=rnd_upto(MAX_OP);  
    } else {
        unsigned data=dice_generator_();
        res=data % MAX_OP;
        //cout << "/* Dice: " << res << ", " << data <<  "*/\n"; /* Avoid some strange bug */
    }
    return res;   
}

bool 
WeakenSafeAnalysesMgr::rnd_wrp_as_deadcode()
{
    return this->rnd_weaken_analysis_i(0);
}

// Add annotation for RRS
std::string 
WeakenSafeAnalysesMgr::annotate_arith_code_wrapper() const
{
	if (CGOptions::enable_annotated_arith_wrappers()) {
		static unsigned int __counter_index = 0; __counter_index++;
		return "/* ___REMOVE_SAFE__OP *//*"+std::to_string(__counter_index-1)+"*//* ___SAFE__OP */";
	} else 	{ 
		return ""; // Skip it if the flag is not on
	}
}