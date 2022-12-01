From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/5] A few cleanup and bugfix patches for blk-iocost
Date: Wed, 30 Nov 2022 19:28:26 -0700
Message-ID: <f4924808-7f53-1ad0-a550-45386fc157ec@kernel.dk>
References: <20221018121932.10792-1-shikemeng@huawei.com>
 <93f9093b-abec-db7e-a945-263cd9355c08@huaweicloud.com>
 <bd008582-1509-69f3-1812-2b9caa390c05@kernel.dk>
 <8d9c98e5-0433-e025-ccec-4144102e91c5@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VQxLjfQwIIvkV52Cq7O9nwAx6kWt8ENkkmDOLlFKoJE=;
        b=Yr+GJT7Asyn8ksHLJb8PHRHQ0PgiYUJS0szobNfBh9q8vCtukZC/KybtLZINJ0r5DD
         D6RqNJK+FJwfuiYlzyckD7Bpawc36ptDJvHEI6BGMdgqQ67CsqJURcaBhkl3ug6zUSYI
         nMOQ2jjDH4voFqRyNAz+EWPJj2fqyptaAec+7QwPx7lLitNthkDdOFhLlr/O4hjkkWg3
         uR4e35sqVKLwqImAZEEZMyo4l6u4iCKZjzrdAJZLJmjLYz2La3KljmRH2U6q248Z0RGW
         QAhEc92zJQ6f3NDlrUzb2LDCq0kEbaWuAj+lMu2aLCtEzaJjpWO2rs6qLWxu6t3WxZ+Y
         +HPQ==
Content-Language: en-US
In-Reply-To: <8d9c98e5-0433-e025-ccec-4144102e91c5@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kemeng Shi <shikemeng@huaweicloud.com>, tj@kernel.org, josef@toxicpanda.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/30/22 7:20=E2=80=AFPM, Kemeng Shi wrote:
>=20
>=20
> on 12/1/2022 9:46 AM, Jens Axboe wrote:
>> On 11/30/22 6:45?PM, Kemeng Shi wrote:
>>>
>>> Hi jens,
>>> on 10/18/2022 8:19 PM, Kemeng Shi wrote:
>>>> This series contain a few patch to correct comment, correct trace of
>>>> vtime_rate and so on. More detail can be found in the respective
>>>> changelogs.
>>>>
>>>> ---
>>>> v2:
>>>>  Thanks Tejun for review and comment!
>>>>  Add Acked-by tag from Tejun.
>>>>  Correct description in patch 3/5 and 4/5.
>>>>  Drop "blk-iocost: Avoid to call current_hweight_max if iocg->inuse
>>>> =3D=3D iocg->active"
>>>>  Drop "blk-iocost: Remove redundant initialization of struct ioc_gq"
>>>>  Drop "blk-iocost: Get ioc_now inside weight_updated"
>>>> ---
>>>>
>>>> Kemeng Shi (5):
>>>>   blk-iocost: Fix typo in comment
>>>>   blk-iocost: Reset vtime_base_rate in ioc_refresh_params
>>>>   blk-iocost: Trace vtime_base_rate instead of vtime_rate
>>>>   blk-iocost: Remove vrate member in struct ioc_now
>>>>   blk-iocost: Correct comment in blk_iocost_init
>>>>
>>>>  block/blk-iocost.c            | 16 +++++++++-------
>>>>  include/trace/events/iocost.h |  4 ++--
>>>>  2 files changed, 11 insertions(+), 9 deletions(-)
>>> Could you apply this patchset?
>>> By the way, my apply for an cloud variant of email was just passed
>>> a few days ago. Is this mail still in spam?
>>
>> This one wasn't, but I've seen the huaweicloud.com emails fail
>> the same origination checks in the past.
> I'm not sure if was there any fix to huaweicloud.com email. I will
> use this huaweicloud emails to minimize the trouble before any
> better solution is found. Sorry for the inconvenience.

Thanks, I'll let you know if I run into issues with the cloud
email.

--=20
Jens Axboe


