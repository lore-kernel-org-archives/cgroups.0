From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Fri, 7 Apr 2023 12:45:47 -0700
Message-ID: <63cf4e4f-764b-8634-b29f-30d45bed1ca5@acm.org>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
 <cab869b1-1cba-5698-55eb-a93d0596c869@acm.org>
 <1416b648-188f-873a-08b3-c8e8494ab1a7@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <1416b648-188f-873a-08b3-c8e8494ab1a7@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Chengming Zhou <zhouchengming@bytedance.com>, tj@kernel.org
Cc: paolo.valente@linaro.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 4/7/23 11:44, Jens Axboe wrote:
> On 4/7/23 12:41=E2=80=AFPM, Bart Van Assche wrote:
>> On 4/6/23 07:50, Chengming Zhou wrote:
>>> These are some cleanup patches of blk-cgroup. Thanks for review.
>>
>> With these patches applied, my kernel test VM crashes during boot. The f=
ollowing crash disappears if I revert these patches:
>>
>> BUG: KASAN: null-ptr-deref in bio_associate_blkg_from_css+0x83/0x240
>=20
> Would be useful in the report to know where that is, as it doesn't include
> the code output.

Hi Jens,

This is what gdb tells me about the crash address:

$ gdb vmlinux
(gdb) list *(bio_associate_blkg_from_css+0x83)
0xffffffff81856923 is in bio_associate_blkg_from_css (./include/linux/blkde=
v.h:865).
860     int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
861                             unsigned int flags);
862
863     static inline struct request_queue *bdev_get_queue(struct block_dev=
ice *bdev)
864     {
865             return bdev->bd_queue;  /* this is never NULL */
866     }
867
868     /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
869     const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);

Thanks,

Bart.
