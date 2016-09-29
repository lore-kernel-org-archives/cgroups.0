From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.9] cpuset: fix error error handling
 regression in proc_cpuset_show()
Date: Thu, 29 Sep 2016 16:27:53 +0300
Message-ID: <20160929132641.GP26713@mwanda>
References: <20160929092722.GA5513@mwanda>
 <20160929095836.GB24034@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160929095836.GB24034-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

That works but there are two other related warnings:

kernel/cgroup.c:5811 proc_cgroup_show() warn: signed compare with PATH_MAX 'retval'
kernel/cgroup.c:6099 cgroup_release_agent() warn: signed compare with PATH_MAX 'ret'

regards,
dan carpenter
