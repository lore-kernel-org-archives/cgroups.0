From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 4 Feb 2015 13:28:11 -0500
Message-ID: <20150204182811.GC18858@htj.dyndns.org>
References: <20150130044324.GA25699@htj.dyndns.org>
 <xr93h9v8yfrv.fsf@gthelen.mtv.corp.google.com>
 <20150130062737.GB25699@htj.dyndns.org>
 <20150130160722.GA26111@htj.dyndns.org>
 <54CFCF74.6090400@yandex-team.ru>
 <20150202194608.GA8169@htj.dyndns.org>
 <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com>
 <54D1F924.5000001@yandex-team.ru>
 <20150204171512.GB18858@htj.dyndns.org>
 <54D25DBD.5080009@yandex-team.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YmXJcAu8dduYMXQFz1MYjADgnQL7a6KeRlHNJ83+DWw=;
        b=OzBdtd6M+vLQLgk5rUTS84chklCNx3WKSyGO5thgDyO3zTFoISFVO+MLCGlz6Rw0Gt
         TScXAmY32dgoQjIXIAs9sw11oqSA7KuS/s6FyIL22CO+OPj2ljlUuQPh59U9fyC1F05U
         EOFMqOYIb3ihtKsdGk3dVO321jMLEVRj3IgWJa8Xr55fsJdD68uabT9sedag1lAL5wFF
         zXTRY6C8AB5dTFIzoJ3QOMcC9XjBA1oWyG/3A5JKxNiJ7fbQ0e8y/Fv3KRNs8lfqqy04
         19wEJO2+RUTUOApLB5jtFBRyl57IZzgusbbuKa4zcmbzRDrBagtHzAJxdxYCNFqpLwt6
         N8Zw==
Content-Disposition: inline
In-Reply-To: <54D25DBD.5080009-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>

On Wed, Feb 04, 2015 at 08:58:21PM +0300, Konstantin Khlebnikov wrote:
> >>Generally incidental sharing could be handled as temporary sharing:
> >>default policy (if inode isn't pinned to memory cgroup) after some
> >>time should detect that inode is no longer shared and migrate it into
> >>original cgroup. Of course task could provide hit: O_NO_MOVEMEM or
> >>even while memory cgroup where it runs could be marked as "scanner"
> >>which shouldn't disturb memory classification.
> >
> >Ditto for annotating each file individually.  Let's please try to stay
> >away from things like that.  That's mostly a cop-out which is unlikely
> >to actually benefit the majority of users.
> 
> Process which scans all files once isn't so rare use case.
> Linux still cannot handle this pattern sometimes.

Yeah, sure, tagging usages with m/fadvise's is fine.  We can just look
at the policy and ignore them for the purpose of determining who's
using the inode, but let's stay away from tagging the files on
filesystem if at all possible.

Thanks.

-- 
tejun
