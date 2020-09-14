From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [Phishing Risk] [External] Re: [PATCH] taskstats: fix
 CGROUPSTATS_CMD_GET for cgroup v2
Date: Mon, 14 Sep 2020 20:48:00 +0800
Message-ID: <32fa7ae0-761f-9f2b-088b-4a3a0b5448cd@bytedance.com>
References: <20200910055207.87702-1-zhouchengming@bytedance.com>
 <20200910143244.GF4295@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Uz3YE9w1fx32lra6fotfj3/BpiuxJjONItcmFYjk970=;
        b=ta92UEnM0Ua9PKVZdAdjsi6Jcm76RRN61MVtg6ALDRhldMa+ZsFdlqJ3vjV7W78eQU
         L+mNnZT19WOv1iAntELNGU/RnT55IXLY4V1fZJk31ruqe/QWsLhn7vTI3wshmsuuW9WE
         xcXv3AmVxLJH5ZH0CPAmEgfxJNjgsRm+aVqtR9u4fHcL5QsDo2ycGJ23JvH5MVGCdwaG
         2gFRVq5A98aqjW2AC4oG5eiDcJm+cDjNRZA2i0KhknZ4KFMoPfj+Rs8soQCCFsQI90dG
         gliLXbww33mVTnbTrDO6SJ3QRT7apUD5L7qeW15VijIPPsRbh5YkpIddinm0fzkgBTwJ
         noNw==
In-Reply-To: <20200910143244.GF4295-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org


在 2020/9/10 下午10:32, Tejun Heo 写道:
> On Thu, Sep 10, 2020 at 01:52:07PM +0800, Chengming Zhou wrote:
>> We found cgroupstats_build would return -EINVAL when using netlink
>> CGROUPSTATS_CMD_GET interface to get stats on cgroup v2. Fix it by
>> supporting cgroup v2 kernfs directory in cgroupstats_build, and export
>> cgroup2_fs_type like we did for cgroup_fs_type.
>>
>> Reported-by: Daowen Luo <luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> Tested-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> The exclusion of cgroupstats from v2 interface was intentional due to the
> duplication and inconsistencies with other statistics. If you need these
> numbers, please justify and add them to the appropriate cgroupfs stat file.
>
> Thanks.
>
Thanks for your advice. The container monitor tool "cadvisor" needs
these numbers to work,

I will put them in the existing cpu.stat interface.

Thanks.

