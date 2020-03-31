From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] bio: track timestamp of submitting bio the
 disk driver
Date: Tue, 31 Mar 2020 01:25:05 -0700
Message-ID: <20200331082505.GA14655@infradead.org>
References: <20200327062859.GA12588@192.168.3.9>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uHShfLyk+r2NtFiic0iTbAAoXgVtjC6D8jlMuvt3O8Y=; b=n5ImjXWjPQw04c5uquw6cwixCv
        e578jSqqpyF1jjdfvtctP4mO/a2CkqhQt617UeqcG7Ay5zz1VUbguxYUT4llyz+IPv+tjjh96qvHc
        0MH0wHtTkTJzBE8gaXP/KWsnZQVIKJJeCBxhgBAiZZqKYqelGWUnVX8hEZ92zxLhxjUBaynD1v2tD
        pmqARRpdJOUaIWWZp3UygBsNnMB8s5/qz9kchbFuncuN6HUolUeX/tXdGO9Q8aqlgJNNHDDLd7Svp
        IgnxLJzB3IDZR998Iik9Bvhg8SJ0QMNEkVSXlnqbcLX78f76825WKxw8lW0i7k0w4ByB79f7Z5U+x
        cYLji1bQ==;
Content-Disposition: inline
In-Reply-To: <20200327062859.GA12588-Q0ErXNX1RuZvRBSd6SXyqg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 27, 2020 at 02:28:59PM +0800, Weiping Zhang wrote:
> Change-Id: Ibb9caf20616f83e111113ab5c824c05930c0e523
> Signed-off-by: Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>

This needs a commit description and loose the weird change id.

I also think oyu need to fins a way to not bloat the bio even more,
cgroup is a really bad offender for bio size.
