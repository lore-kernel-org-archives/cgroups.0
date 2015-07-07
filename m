From: Arianna Avanzini <avanzini.arianna@gmail.com>
Subject: Re: [PATCHSET v2 block/for-4.3] blkcg: blkcg_policy methods cleanup
Date: Tue, 07 Jul 2015 22:31:14 +0200
Message-ID: <559C3712.7040505@gmail.com>
References: <1436284293-4666-1-git-send-email-tj@kernel.org> <20150707200047.GC23362@mtj.duckdns.org>
Reply-To: Arianna Avanzini <avanzini.arianna@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:reply-to
         :user-agent:mime-version:to:cc:subject:references:in-reply-to
         :content-type:content-transfer-encoding;
        bh=m7qJgqvGhaS/D5IYjfEOS3b76fCfpXurmeHhmbYPOFY=;
        b=uE8DRLz6OrD2QTo4fBQLOGiLVE0yRV5aMK9kE2W837Ux+0pf/wngvk80hQrSLf1RhJ
         dXfdTp9hDUxM1uW/iF9TS2TCh+H9PRJzHDcsaThRAGbPJez18L2an2BjPcyZ9T0MU56P
         ESj2mTdusFHAvYoxEwamTjny8TlkGPSs8lgq3ckzhnmAAKhWKuJFgWffFsB1uARFIMqT
         lrYer47ra+VGhcaK7y1bWfQeZW1rMW6y/Hjc1lqQnqoJuOAiClUTlBxES+4qiqGb+Ji8
         cFcCB8QYKugBYPXWWTpyKTb3PeAAI8mXgnql4HR9m5u/K2i/qKCmrbaxf/6yL9qpEEbf
         EUlA==
In-Reply-To: <20150707200047.GC23362@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com

Hi Tejun,

Il 07/07/2015 22:00, Tejun Heo ha scritto:
> On Tue, Jul 07, 2015 at 11:51:26AM -0400, Tejun Heo wrote:
>> This is v2 of blkcg_policy methods cleanup patchset.  Changes from the
>> last take [L] are
>>
>> * Rebased on top of v4.2-rc1 and other pending patches.  v4.2-rc1
>>    added a patch to add per-blkcg policy data which is allocated by
>>    blkcg core as per-blkcg_gq policy data was before this patchset
>>    making the two inconsistent.  I'll follow up with per-blkcg policy
>>    data update.
>
> While updating per-blkcg policy data handling, I discovered a couple
> bugs in policy data handling which should be backported through
> -stable.  I'll put those earlier in the series and repost this
> patchset.  Please ignore this one for now.
>

I think Jens just applied a bugfix for per-blkcg policy data handling. Please 
have a look at https://lkml.org/lkml/2015/7/6/950. Should have Cc'd you, sorry 
for that.

Thanks,
Arianna
