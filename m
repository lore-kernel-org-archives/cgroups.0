From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 29 Nov 2013 09:33:10 +0100
Message-ID: <CA+SBX_OvhQ61a9X0UMEQE7GhJKCsrh+tWrQ+vTuoZvFrRGKjmg@mail.gmail.com>
References: <20131118094554.GA32623@dhcp22.suse.cz>
	<CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A@mail.gmail.com>
	<20131118191655.GB12923@dhcp22.suse.cz>
	<CA+SBX_OeGCr5oDbF0n7jSLu-TTY9xpqc=LYp_=18qFYHB-nBdg@mail.gmail.com>
	<20131121164559.GA16703@dhcp22.suse.cz>
	<CA+SBX_PDuU7roist-rQ136Jhx1pr-Nt-r=ULdghJFNHsMWwLrg@mail.gmail.com>
	<20131122145033.GE25406@dhcp22.suse.cz>
	<CA+SBX_O_+WbZGUJ_tw_EWPaSfrWbTgQu8=GpGpqm0sizmmP=cA@mail.gmail.com>
	<20131126152124.GC32639@dhcp22.suse.cz>
	<CA+SBX_Mb0EwvmaejqoW4mtYbiOTV6yV3VrLH7=s0wX-6rH7yDA@mail.gmail.com>
	<20131128170536.GA17411@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=aI4Mr8LHNoIa42BlKEsPFLSnNmfumpSohH1Nz9VCK8I=;
        b=EMq8GiJ7sr2UeYHPIGPx8sfalCKAPDD8OXMIH/EqlHx/Fegw02ghdOBDEfQV+8D2re
         QGbizBx4hlG+EALTUBaq6LOk/czNSsLR9550aeocUuEbzuWXMElYlW1pAmWVMgCRI9+8
         3NkG9Aquf2vdrgcYzDIbSxnP3fO5FHJTZg+RC2krurbR/CQQ7GG06oPiEUnlqKGHpaOn
         9Zx1cSFFi4vl78OgMU5xi/nT9L3EN2oJzryv5FmZzQ/190oUIkTMtIqz6uZB1JwN9K6c
         HVL35GW/3U4ojSoLQQGIvAwGNQHL6oin3DFtkf5qNYco1Sm01X436/aHiExN5uZd0C7s
         divQ==
In-Reply-To: <20131128170536.GA17411-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The migration part is disabled because we had another problem with
this specific plugin. Today I saw a post on the slurm mailing list,
eventually describing the same problem, also with 3.11:
https://groups.google.com/forum/#!topic/slurm-devel/26nTXLcL3yI

Basically I have many small jobs scheduled for a maximum runtime of 10
seconds, starting at the same time and therefore also ending at the
same time .. this reproduces it within seconds on my test node within
the cluster. I hope that I can reproduce this on my desktop machine
and try to come up with a simple script, but this might take a few
days.


On Thu, Nov 28, 2013 at 6:05 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Tue 26-11-13 22:05:47, Markus Blank-Burian wrote:
>> > OK, this would suggest that some charges were accounted to a different
>> > group than the corresponding pages group's LRUs or that the charge cache (stock)
>> > is b0rked (the later can be checked easily by making refill_stock a noop
>> > - see the patch below - I am skeptical that would help though).
>>
>> You were right, still no change.
>>
>> > Let's rule out some usual suspects while I am staring at the
>> > code. Are the tasks migrated between groups? What is the value of
>> > memory.move_charge_at_immigrate?  Have you seen any memcg oom messages
>> > in the log?
>>
>> - i dont see anything about migration, but there is a part about
>> setting "memory.force_empty". i did not see the corresponding trace
>> output .. but i will recheck this. (see
>> https://github.com/SchedMD/slurm/blob/master/src/plugins/jobacct_gather/cgroup/jobacct_gather_cgroup_memory.c)
>
>         if (xcgroup_create(&memory_ns, &memory_cg, "", 0, 0)
>          == XCGROUP_SUCCESS) {
>                 xcgroup_set_uint32_param(&memory_cg, "tasks", getpid());
>                 xcgroup_destroy(&memory_cg);
>                 xcgroup_set_param(&step_memory_cg, "memory.force_empty", "1");
>         }
>
> So the current task is moved to memory_cg which is probably root and
> then it tries to free memory by writing to force_empty.
>
>> - the only interesting part of the release_agent is the removal of the
>> cgroup hierarchy (mountdir is /sys/fs/cgroup/memory): flock -x
>> ${mountdir} -c "rmdir ${rmcg}"
>
> OK, so only a single group is removed at the time.
>
>> - memory.move_charge_at_immigrate is "0"
>
> OK, so the pages of the moved process stay in the original group. This
> rules out races of charge with move.
>
> I have checked the charging paths and we always commit (set memcg to
> page_cgroup) to the charged memcg. The only more complicated case is
> swapin but you've said you do not have any swap active.
>
> I am getting clueless :/
>
> Is your setup easily replicable so that I can play with it?
>
>> - i never saw any oom messages related to this problem. i checked
>> explicitly before reporting the first time, if this might somehow be
>> oom-related
>
> --
> Michal Hocko
> SUSE Labs
