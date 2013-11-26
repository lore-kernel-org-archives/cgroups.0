From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 26 Nov 2013 22:47:57 +0100
Message-ID: <CA+SBX_MQRVpqDJ2+YgTOFtc2oX3ojHsDBT7JQdc4pCHiBS061g@mail.gmail.com>
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
        bh=sThfmRzKaIUWogne/hEymyvBJRR28SkGYO4XsMnOBFk=;
        b=OXtMIS3kU5vsoGuKy3yntPM1O0ekkkU4hP26B2RN1ioQ0Xqquv8RCSe9HjUNJaZ/cP
         /qE6V5pdHItA5ryxuR87WXminQoa/bakFt/gt+ngvtwLd+UdDk0Lpkd1figCTWH6wzyh
         h8vLYO8Rb7L8HT9ESKBL++u8V2Cy/Dyr7oIv1mh3VNtKqkAkUqBHp7pU3Z/3VjkvHxao
         ty2k9cOjlPi7EQsEXrZZvCPvvYFftNnUcMV3lMK+1YXFnXvYeSLJNEEVurNi3vMF1u+t
         1K7P8XKybhV2f2QJ9pNNzn1ldaDc05l+8g10cmCDffJ2QrttyingbGIcyJVOo1MKtxEr
         vTYw==
In-Reply-To: <20131126152124.GC32639-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Are the tasks migrated between groups?

its getting late. the jobacct_gather plugin is disabled here because
it is marked as experimental, so the code migrating the task to the
root group and setting force_empty is not executed.

the only code executed (besides the rmdir from the release_agent) is in
https://github.com/SchedMD/slurm/blob/master/src/plugins/task/cgroup/task_cgroup_memory.c

the release_agent is found here (in case i missed something):
https://github.com/SchedMD/slurm/blob/master/etc/cgroup.release_common.example

As far as i can see, this locks the root memory cgroup prior to
deleting the corresponding subtree. In the logfile, there are the
following error messages, indicating that only the innermost child
group for the jobstep could be deleted, but not its parents (hierarchy
is /sys/fs/cgroup/memory/slurm/uid_x/job_xxxx/step_xxxxxxxxx).
[2013-11-26T21:38:59.583] [62044.0] task/cgroup: not removing job
memcg : Device or resource busy
[2013-11-26T21:38:59.583] [62044.0] task/cgroup: not removing user
memcg : Device or resource busy
