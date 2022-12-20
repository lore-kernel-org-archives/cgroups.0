From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next 0/4] blk-cgroup: synchronize del_gendisk() with
 configuring cgroup policy
Date: Tue, 20 Dec 2022 06:01:30 -1000
Message-ID: <Y6HcWiJbaWjN3jlt@slm.duckdns.org>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
 <Y6DP3aOSad8+D1yY@slm.duckdns.org>
 <e01daffe-a3e3-8bf2-40ee-192a9e70d911@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CZMmU+pGQ8I5cymzBUpFRodcntV5ODz7Rjd+p+IjcxM=;
        b=FgJB7RQvMGsU5maNwk7Ibn2Kug3rClLlbV+23BVAoBFTwzYdicUZXx3BxJFCWZACEC
         POblY96MELR7T8nVNu6GLXbVj3mdBhx9OWg+ZlzMjrulDNLSzZubdpBOCyAOuYAk1GLg
         6rEUYa4jn5ws84VoWzD+jGpalbsPbcEv6MtfvQfmUe3Bwh0ZymytgdtxzCe4SAxSrrZW
         JRsTSU42YJ8g0PZRLD5Dt3rOnvuYZyElq0JPi8DYrCTyyg7ARVSRAGy7Z5/+NF+zqMkJ
         O+XjDFoi/9ao4U8frNn+BxeKGEMMB+OkJytTxfidyNroPX4BqWLhwMp6/SNiMJGUxwc6
         GPyQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e01daffe-a3e3-8bf2-40ee-192a9e70d911-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Dec 20, 2022 at 05:19:12PM +0800, Yu Kuai wrote:
> Yes, that sounds good. BTW, queue_lock is also used to protect
> pd_alloc_fn/pd_init_fn=EF=BC=8Cand we found that blkcg_activate_policy() =
is
> problematic:
>=20
> blkcg_activate_policy
>  spin_lock_irq(&q->queue_lock);
>  list_for_each_entry_reverse(blkg, &q->blkg_list
>   pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN,...) -> failed
>=20
>   spin_unlock_irq(&q->queue_lock);
>   // release queue_lock here is problematic, this will cause
> pd_offline_fn called without pd_init_fn.
>   pd_alloc_fn(__GFP_NOWARN,...)

So, if a blkg is destroyed while a policy is being activated, right?

> If we are using a mutex to protect rq_qos ops, it seems the right thing
> to do do also using the mutex to protect blkcg_policy ops, and this
> problem can be fixed because mutex can be held to alloc memroy with
> GFP_KERNEL. What do you think?

One worry is that switching to mutex can be more headache due to destroy
path synchronization. Another approach would be using a per-blkg flag to
track whether a blkg has been initialized.

Thanks.

--=20
tejun
