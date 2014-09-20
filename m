From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: use a per-cgroup work for release agent
Date: Sat, 20 Sep 2014 10:32:23 +0800
Message-ID: <541CE737.8050801@huawei.com>
References: <20140919160906.GA1575@mwanda>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140919160906.GA1575@mwanda>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/9/20 0:09, Dan Carpenter wrote:
> Hello Zefan Li,
> 
> The patch 971ff4935538: "cgroup: use a per-cgroup work for release
> agent" from Sep 18, 2014, leads to the following static checker
> warning:
> 
> 	kernel/cgroup.c:5310 cgroup_release_agent()
> 	warn: 'mutex:&cgroup_mutex' is sometimes locked here and sometimes unlocked.
> 

Thanks! Will send out the fix soon.
