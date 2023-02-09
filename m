From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Thu, 9 Feb 2023 11:09:33 -0800
Message-ID: <55a065e7-7d86-d58f-15ba-c631a427843e@acm.org>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
 <4f7dcb3e-2d5a-cae3-0e1c-a82bcc3d2217@huaweicloud.com>
 <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
 <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
 <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
 <20230208134345.77bdep3kzp52haxu@quack3>
 <7fcd4c38-ccbe-6411-e424-a57595ad9c0b@acm.org>
 <20230209085603.dzqfcc3pp4hacqlz@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230209085603.dzqfcc3pp4hacqlz@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On 2/9/23 00:56, Jan Kara wrote:
> On Wed 08-02-23 09:53:41, Bart Van Assche wrote:
>> The test results I shared some time ago show that IOPRIO_CLASS_NONE was the
>> default I/O priority two years ago (see also https://lore.kernel.org/linux-block/20210927220328.1410161-5-bvanassche@acm.org/).
>> The none-to-rt policy increases the priority of bio's that have not been
>> assigned an I/O priority to RT. Does this answer your question?
> 
> Not quite. I know that historically we didn't set bio I/O priority in some
> paths (but we did set it in other paths such as some (but not all) direct
> IO implementations). But that was exactly a mess because how none-to-rt
> actually behaved depended on the exact details of the kernel internal IO
> path.  So my question is: Was none-to-rt actually just a misnomer and the
> intended behavior was "always override to RT"? Or what was exactly the
> expectation around when IO priority is not set and should be overridden?
> 
> How should it interact with AIO submissions with IOCB_FLAG_IOPRIO? How
> should it interact with task having its IO priority modified with
> ioprio_set(2)? And what if task has its normal scheduling priority modified
> but that translates into different IO priority (which happens in
> __get_task_ioprio())?
> 
> So I think that none-to-rt is just poorly defined and if we can just get
> rid of it (or redefine to promote-to-rt), that would be good. But maybe I'm
> missing some intended usecase...

Hi Jan,

We have no plans to use the ioprio_set() system call since it only 
affects foreground I/O and not page cache writeback.

While Android supports io_uring, there are no plans to support libaio in 
the Android C library (Bionic).

Regarding __get_task_ioprio(), I haven't found any code in that function 
that derives an I/O priority from the scheduling priority. Did I perhaps 
overlook something?

Until recently "none-to-rt" meant "if no I/O priority has been assigned 
to a task, use IOPRIO_CLASS_RT". Promoting the I/O priority to 
IOPRIO_CLASS_RT works for us. I'm fine with changing the meaning of 
"none-to-rt" into promoting the I/O priority class to RT. Introducing 
"promote-to-rt" as a synonym of "none-to-rt" is also fine with me.

Thanks,

Bart.
