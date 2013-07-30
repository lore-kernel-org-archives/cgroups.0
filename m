From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
Date: Tue, 30 Jul 2013 09:58:58 +0800
Message-ID: <51F71DE2.4020102@huawei.com>
References: <20130723174711.GE21100@mtj.dyndns.org> <8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz> <87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz> <20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r4eh70yg.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

> I am also seeing what looks like a leak somewhere in the cgroup code as
> well.  After some runs of the same reproducer I get into a state where
> after everything is clean up.  All of the control groups have been
> removed and the cgroup filesystem is unmounted, I can mount a cgroup
> filesystem with that same combindation of subsystems, but I can't mount
> a cgroup filesystem with any of those subsystems in any other
> combination.  So I am guessing that the superblock is from the original
> mounting is still lingering for some reason.
> 

If this happens again, you can check /proc/cgroups, 

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
debug   0       1       1
cpu     0       1       1
cpuacct 0       1       1
memory  0       1       1
devices 0       1       1
freezer 0       1       1
blkio   0       1       1

If "hierachy" is not 0, then it didn't really unmounted. If "num_cgroups"
is not 1, then there're some cgroups not really destroyed though they've
been rmdired.
