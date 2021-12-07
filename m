From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Date: Tue, 7 Dec 2021 15:53:54 +0100
Message-ID: <28ded939-6339-c9e1-c0a3-ff84fb197eed@applied-asynchrony.com>
References: <20211201133439.3309-1-jack@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211201133439.3309-1-jack@suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, fvogt@suse.de, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, stable@vger.kernel.org, Fabian Vogt <fvogt@suse.com>


On 2021-12-01 14:34, Jan Kara wrote:
> BFQ started crashing with 5.15-based kernels like:
> 
> BUG: KASAN: use-after-free in rb_erase (lib/rbtree.c:262 lib/rbtr
> Read of size 8 at addr ffff888008193098 by task bash/1472
[snip]

This does not compile when CONFIG_BFQ_GROUP_IOSCHED is disabled.
I know the patch is meant for the case where it is enabled, but still..

block/bfq-iosched.c: In function 'bfq_init_bfqq':
block/bfq-iosched.c:5362:51: error: 'struct bfq_group' has no member named 'children'
  5362 |         hlist_add_head(&bfqq->children_node, &bfqg->children);
       |                                                   ^~
make[1]: *** [scripts/Makefile.build:277: block/bfq-iosched.o] Error 1

Probably just needs a few more ifdefs :)

cheers
Holger
