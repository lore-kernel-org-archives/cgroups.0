From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Fri, 7 Jan 2022 09:04:45 +0800
Message-ID: <44c41001-c072-8e13-77e3-c19b8c12ab41@huawei.com>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-5-yukuai3@huawei.com>
 <20211221115001.GD24748@quack2.suse.cz>
 <6ca1e924-47fa-b94e-598c-69a9549eb68e@huawei.com>
 <20211222141722.GC685@quack2.suse.cz>
 <9743fc5a-f3f0-a23a-5d21-0c04c90e90e1@huawei.com>
 <5b42943f-4a8e-c4ec-05da-57e36cc14113@huawei.com>
 <20220103153732.pcfsmadzlqqroxcj@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220103153732.pcfsmadzlqqroxcj@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/01/03 23:37, Jan Kara 写道:
> OK, thanks for following up on this. So do I understand you correctly that
> the problem with empty bfqq being in pos_tree does not exist in current
> upstream kernel?

Yes, I had this patch removed in v2 patchset.

Thanks,
Kuai
