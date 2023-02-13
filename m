From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Mon, 13 Feb 2023 09:10:26 -0800
Message-ID: <0290f608-6ddf-ecb7-4c05-55b0f7dbfbea@acm.org>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
 <4f7dcb3e-2d5a-cae3-0e1c-a82bcc3d2217@huaweicloud.com>
 <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
 <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
 <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
 <20230208134345.77bdep3kzp52haxu@quack3>
 <7fcd4c38-ccbe-6411-e424-a57595ad9c0b@acm.org>
 <20230209085603.dzqfcc3pp4hacqlz@quack3>
 <55a065e7-7d86-d58f-15ba-c631a427843e@acm.org>
 <20230210101244.zsmtmsoo4xjx7suj@quack3>
 <48620099-0311-e752-ba3b-cbb4351cf81e@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <48620099-0311-e752-ba3b-cbb4351cf81e@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hou Tao <houtao@huaweicloud.com>, Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On 2/13/23 04:51, Hou Tao wrote:
> Should I keep "none-to-rt" and make it work just like "promote-to-rt" or should
> I just remove "none-to-rt" and add "promote-to-rt" ? I think the latter will be
> more appropriate.

Removing none-to-rt would break existing systems that use this policy. I 
prefer the former solution.

Thanks,

Bart.

