From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup/for-4.6 1/2] cgroup: re-hash init_css_set after
 subsystems are initialized
Date: Thu, 3 Mar 2016 11:05:09 +0800
Message-ID: <56D7A9E5.2030507@huawei.com>
References: <20160302180712.GA11029@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160302180712.GA11029-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 2016/3/3 2:07, Tejun Heo wrote:
> css_sets are hashed by their subsys[] contents and in cgroup_init()
> init_css_set is hashed early, before subsystem inits, when all entries
> in its subsys[] are NULL, so that cgroup_dfl_root initialization can
> find and link to it.  As subsystems are initialized,
> init_css_set.subsys[] is filled up but the hashing is never updated
> making init_css_set hashed in the wrong place.  While incorrect, this
> doesn't cause a critical failure as css_set management code would
> create an identical css_set dynamically.
> 
> Fix it by rehashing init_css_set after subsystems are initialized.
> While at it, drop unnecessary @key local variable.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

For both patches:

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
