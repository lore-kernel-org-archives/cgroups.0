From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: Possible mem cgroup bug in kernels between 4.18.0 and 5.3-rc1.
Date: Mon, 5 Aug 2019 23:00:12 +0900
Message-ID: <0b817204-29f4-adfb-9b78-4fec5fa8f680@i-love.sakura.ne.jp>
References: <20190802074047.GQ11627@dhcp22.suse.cz>
 <7E44073F-9390-414A-B636-B1AE916CC21E@apple.com>
 <20190802144110.GL6461@dhcp22.suse.cz>
 <5DE6F4AE-F3F9-4C52-9DFC-E066D9DD5EDC@apple.com>
 <20190802191430.GO6461@dhcp22.suse.cz>
 <A06C5313-B021-4ADA-9897-CE260A9011CC@apple.com>
 <f7733773-35bc-a1f6-652f-bca01ea90078@I-love.SAKURA.ne.jp>
 <d7efccf4-7f07-10da-077d-a58dafbf627e@I-love.SAKURA.ne.jp>
 <20190805084228.GB7597@dhcp22.suse.cz>
 <7e3c0399-c091-59cd-dbe6-ff53c7c8adc9@i-love.sakura.ne.jp>
 <20190805114434.GK7597@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190805114434.GK7597@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masoud Sharbiani <msharbiani@apple.com>, Greg KH <gregkh@linuxfoundation.org>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2019/08/05 20:44, Michal Hocko wrote:
>> Allowing forced charge due to being unable to invoke memcg OOM killer
>> will lead to global OOM situation, and just returning -ENOMEM will not
>> solve memcg OOM situation.
> 
> Returning -ENOMEM would effectivelly lead to triggering the oom killer
> from the page fault bail out path. So effectively get us back to before
> 29ef680ae7c21110. But it is true that this is riskier from the
> observability POV when a) the OOM path wouldn't point to the culprit and
> b) it would leak ENOMEM from g-u-p path.
> 

Excuse me? But according to my experiment, below code showed flood of
"Returning -ENOMEM" message instead of invoking the OOM killer.
I didn't find it gets us back to before 29ef680ae7c21110...

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1884,6 +1884,8 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
        mem_cgroup_unmark_under_oom(memcg);
        if (mem_cgroup_out_of_memory(memcg, mask, order))
                ret = OOM_SUCCESS;
+       else if (!(mask & __GFP_FS))
+               ret = OOM_SKIPPED;
        else
                ret = OOM_FAILED;

@@ -2457,8 +2459,10 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
                goto nomem;
        }
 nomem:
-       if (!(gfp_mask & __GFP_NOFAIL))
+       if (!(gfp_mask & __GFP_NOFAIL)) {
+               printk("Returning -ENOMEM\n");
                return -ENOMEM;
+       }
 force:
        /*
         * The allocation either can't fail or will lead to more memory
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1071,7 +1071,7 @@ bool out_of_memory(struct oom_control *oc)
         * ___GFP_DIRECT_RECLAIM to get here.
         */
        if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS))
-               return true;
+               return !is_memcg_oom(oc);

        /*
         * Check if there were limitations on the allocation (only relevant for
