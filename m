From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 26 Nov 2013 16:21:24 +0100
Message-ID: <20131126152124.GC32639@dhcp22.suse.cz>
References: <20131112135844.GA6049@dhcp22.suse.cz>
 <CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw@mail.gmail.com>
 <20131118094554.GA32623@dhcp22.suse.cz>
 <CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A@mail.gmail.com>
 <20131118191655.GB12923@dhcp22.suse.cz>
 <CA+SBX_OeGCr5oDbF0n7jSLu-TTY9xpqc=LYp_=18qFYHB-nBdg@mail.gmail.com>
 <20131121164559.GA16703@dhcp22.suse.cz>
 <CA+SBX_PDuU7roist-rQ136Jhx1pr-Nt-r=ULdghJFNHsMWwLrg@mail.gmail.com>
 <20131122145033.GE25406@dhcp22.suse.cz>
 <CA+SBX_O_+WbZGUJ_tw_EWPaSfrWbTgQu8=GpGpqm0sizmmP=cA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HTPygIoR3DZDli+VT3GzR2JOUncAHFGBbvWVzuOFBvI=;
        b=OVWzsWiDVpuaJjQ+OF3h5ld5i1L0xJMI3I+MIl0s4hp6VZg14S6K7XOxg4PHlLhxZu
         gszY5x9Q3ZoKKC1L9FlLlCf4vK+yFR9VkQZcOM2IRU2wqqRQhnoqEAl1Zw2CFU0IjGPW
         4leJdQ3R/qdbg+17NwOohXNCW9iPHsAq1RW2d9Av9cUxGYAlAccnCJ/8iGBQoWjrchGv
         9suwEVwl9vTBoKJVZ58SK0AlFslBE26NE9yWwJ+LvSp/bYpfQDXlgbPRU157WwTBY0ID
         wE4VylquCNy3GAGU24x7OJnWr368PCGQMzj0+Ww6ZA5UT2nnWykRP7vH6KRchPq7vTwT
         vV0A==
Content-Disposition: inline
In-Reply-To: <CA+SBX_O_+WbZGUJ_tw_EWPaSfrWbTgQu8=GpGpqm0sizmmP=cA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 25-11-13 15:03:50, Markus Blank-Burian wrote:
> > Maybe it is stuck on some other blocking operation (you've said you have
> > the fix for too many workers applied, right?)
> >
> 
> For the last trace, I had not applied the cgroup work queue patch.

OK, that makes more sense now. The worker was probably hanging on
lru_add_drain_all waiting for its per-cpu workers or something like that.

> I just made some new traces with the applied patch, same problem. Now
> there is only the one unmatched "going offline" from the thread which
> actually gets stuck in "reparent charges".

OK, this would suggest that some charges were accounted to a different
group than the corresponding pages group's LRUs or that the charge cache (stock)
is b0rked (the later can be checked easily by making refill_stock a noop
- see the patch below - I am skeptical that would help though).

Let's rule out some usual suspects while I am staring at the
code. Are the tasks migrated between groups? What is the value of
memory.move_charge_at_immigrate?  Have you seen any memcg oom messages
in the log?

---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index afe7c84d823f..de8375463d59 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2455,14 +2455,7 @@ static void __init memcg_stock_init(void)
  */
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
-
-	if (stock->cached != memcg) { /* reset if necessary */
-		drain_stock(stock);
-		stock->cached = memcg;
-	}
-	stock->nr_pages += nr_pages;
-	put_cpu_var(memcg_stock);
+	return;
 }
 
 /*
-- 
Michal Hocko
SUSE Labs
