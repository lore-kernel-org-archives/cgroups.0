From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 26 Nov 2013 22:05:47 +0100
Message-ID: <CA+SBX_Mb0EwvmaejqoW4mtYbiOTV6yV3VrLH7=s0wX-6rH7yDA@mail.gmail.com>
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
	<20131126152124.GC32639@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=AJnARch3lFi/MXtHgfECXMmPKtKWaRB9pGhzE4mRoac=;
        b=l6u72/xxTnxIJHnZtCF5ySFtPS7JltEOkIMClGAUm/UaLpDAXVKCzvequTv6ZFHrc8
         CQ88VHoTYfZF2hwpfBlFMk2MovOavXKipWUcLttnHpHePRr3tOi1PNz+QJ45+CMGz5RE
         K0NRROSnGJj2B6WVUTJLxDUaloBo/qfNpkmrxCn6b1ErdB73d7QbFGXzF18OqJaeQ2yl
         BQjwuq4zOSFU9lAvgMyvv5dLzeT9ldsc8d5z73B3casbm965U5NgOCdC8Qi9PX/x2afE
         4lH1RKVOCJhVLFmILkLh0FjyUwDniMXyrqYKhEsqFntnsphifmV/GxRm0lnR4OW41fru
         S8Wg==
In-Reply-To: <20131126152124.GC32639-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> OK, this would suggest that some charges were accounted to a different
> group than the corresponding pages group's LRUs or that the charge cache (stock)
> is b0rked (the later can be checked easily by making refill_stock a noop
> - see the patch below - I am skeptical that would help though).

You were right, still no change.

> Let's rule out some usual suspects while I am staring at the
> code. Are the tasks migrated between groups? What is the value of
> memory.move_charge_at_immigrate?  Have you seen any memcg oom messages
> in the log?

- i dont see anything about migration, but there is a part about
setting "memory.force_empty". i did not see the corresponding trace
output .. but i will recheck this. (see
https://github.com/SchedMD/slurm/blob/master/src/plugins/jobacct_gather/cgroup/jobacct_gather_cgroup_memory.c)
- the only interesting part of the release_agent is the removal of the
cgroup hierarchy (mountdir is /sys/fs/cgroup/memory): flock -x
${mountdir} -c "rmdir ${rmcg}"
- memory.move_charge_at_immigrate is "0"
- i never saw any oom messages related to this problem. i checked
explicitly before reporting the first time, if this might somehow be
oom-related
