From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Thu, 27 Jan 2022 13:03:35 +0800
Message-ID: <YfInp7SsZNNgRfB7@T590>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com>
 <Yd5FkuhYX9YcgQkZ@T590>
 <b416e6a6-f2c9-caf3-dacd-f937746207da@huawei.com>
 <YfF+yukISfkuc9IK@slm.duckdns.org>
 <630c162b-8bdd-d87e-0d80-c7a78ea267a5@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643259847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=plPajYXA8B5ZLakDfOB/mq6gwvfYbK84k4ZYLKgoU6w=;
        b=K/uusz10UWBF0kNGSINnxEN0rCT9PEtgs0Tclz6pdbMLSqFnmN/dtncCELtyt2KO0VO0jp
        Y4w5DWy3PwS0uxyDYySqf8FwRTs4tQOAoujs2KgIMolnLTikqHKRCKaVoSRc/Nhc/aSOmp
        3DFiAp4+oaKwgSfPzBhdL7j2CV1GXIY=
Content-Disposition: inline
In-Reply-To: <630c162b-8bdd-d87e-0d80-c7a78ea267a5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu, Jan 27, 2022 at 10:45:33AM +0800, yukuai (C) wrote:
> 在 2022/01/27 1:03, Tejun Heo 写道:
> > On Mon, Jan 24, 2022 at 11:50:11AM +0800, yukuai (C) wrote:
> > > Both ways can fix the problem, which way do you prefer?
> > 
> > Ming's suggested change seems simpler, no?
> 
> Hi,
> 
> Yes, if Ming don't mind, I can send a new version after Ming's
> pathset "block: don't drain file system I/O on del_gendisk".

The patch of canceling throttled bios shouldn't be conflicted
with the above big patchset, and you can send it out now against
for-5.18/block.


Thanks,
Ming

