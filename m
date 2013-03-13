From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: in.tftpd - ulimit -u not working? cgroups?
Date: Wed, 13 Mar 2013 16:37:58 +0100
Message-ID: <20130313153758.GB13959@dhcp22.suse.cz>
References: <20130311144737.GA7024@pcnci.linuxbox.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130311144737.GA7024-xTMdSLfc3Wpi51D5yjT6kKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikola Ciprich <nikola.ciprich-Jp3n8lUXroTtwjQa/ONI9g@public.gmane.org>
Cc: linux-kernel mlist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 11-03-13 15:47:37, Nikola Ciprich wrote:
[...]
> I also tried limiting memory using cgroups, but even with limit of
> 2MB, it can spawn much more processes than I'd like, and 1MB is too
> low... 

If you were using memory cgroup then be aware that the controller covers
only user space allocations by default which doesn't prevent forks from
creating new processes.

> Is it possible to limit number of processes using cgroups?

You might be interested in KMEM (CONFIG_MEMCG_KMEM) extension for memory
cgroup (see Documentation/cgroups/memory.txt "2.7 Kernel Memory Extension
(CONFIG_MEMCG_KMEM)" for more information)
-- 
Michal Hocko
SUSE Labs
