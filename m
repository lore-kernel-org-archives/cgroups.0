From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4 3/3] cgroup: replace unified-hierarchy.txt
 with a proper cgroup v2 documentation
Date: Thu, 22 Oct 2015 10:34:27 -0400
Message-ID: <20151022143427.GC20847@redhat.com>
References: <20151022012212.GA20931@mtj.duckdns.org>
 <20151022012302.GB20931@mtj.duckdns.org>
 <20151022012354.GC20931@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151022012354.GC20931-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Oct 22, 2015 at 10:23:54AM +0900, Tejun Heo wrote:

[..]
> +5-3-2. Writeback
> +
> +Writeback of page cache manages the dirty memory ratio and is an
> +integral part of memory management.  The io controller, in conjunction
> +with the memory controller, implements control of page cache writeback
> +IOs.  The memory controller defines the memory domain that dirty
> +memory ratio is calculated and maintained for and the io controller
> +defines the io domain which writes out dirty pages for the memory
> +domain.

Hi Tejun,

Glad that finally devel flag will go away and new shiny unified hierarchy
can be used using cgroup2 fstype. Thanks for all this hard work.

Will it make sense to also talk about what filesystems currently writeback
cgroup work with. IIUC, currently this works with ext2 and there are plans to
make it work with other filesystems.

Thanks
Vivek
