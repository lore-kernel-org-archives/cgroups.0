From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/8] cgroup: document how cgroup IDs are assigned
Date: Tue, 30 Jul 2013 09:08:14 +0800
Message-ID: <51F711FE.3040006@huawei.com>
References: <51F614B2.6010503@huawei.com> <51F614D4.6000703@huawei.com> <20130729182632.GC26076@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130729182632.GC26076-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 2013/7/30 2:26, Tejun Heo wrote:
> On Mon, Jul 29, 2013 at 03:08:04PM +0800, Li Zefan wrote:
>> As cgroup id has been used in netprio cgroup and will be used in memcg,
>> it's important to make it clear how a cgroup id is allocated.
>>
>> For example, in netprio cgroup, the id is used as index of anarray.
>>
>> Signed-off-by: Li Zefan <lizefan-Z5rXVj2qdvIAvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> We can merge this into the first patch?
> 

The first patch just changes ida to idr, it doesn't change how IDs are
allocated, so I prefer make this a standalone patch.
