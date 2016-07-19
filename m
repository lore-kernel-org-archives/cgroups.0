From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Tue, 19 Jul 2016 16:59:18 +0000
Message-ID: <45e50dcb-7446-d203-de6e-0a59dc09a874@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
 <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
 <20160613213354.GH31708@htj.duckdns.org>
 <3b03822f-c5d0-5b84-79c3-edeb8e78e2dd@gmail.com>
 <20160719010931.GG3078@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=m56YeQ4RNIUigbXDePIiUTLIyKrOED7t2EtURhECY4o=;
        b=RIQupGIqBHsGsBs7IwM+Y2OlYLN5AsEw0/O0nvV4mO2JhhKD31g79dlWjRBO/uTKmZ
         lVn3NpKLpTruAgvOcqoW8vuTSqF/5W7rBCbSDLw+/bC82/FE6p20mCNKJG5brtbKe34G
         Cllbt+PDOpouQyYtr/9ZYKHxghPe3bqKo20GA6HX6UeSzP6gU2j/OoiSTE7+yqWEsUUz
         EbGSVCPyPBgZ9vuOxaJnyCoINpdvhHlgZrFbikTV2zIKuejMxi6zwzONm50yexlyOK3d
         Zqnzm4TFX7V8Bef6bahKSwz0qNwXI8ORRtAVCvcavuAjOzUu66crwZ91TAyp6De/Kdtg
         nJyw==
In-Reply-To: <20160719010931.GG3078@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

On 07/19/16 01:09, Tejun Heo wrote:
> On Sun, Jul 17, 2016 at 08:11:31PM +0000, Topi Miettinen wrote:
>> On 06/13/16 21:33, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Mon, Jun 13, 2016 at 09:29:32PM +0000, Topi Miettinen wrote:
>>>> I used fork callback as I don't want to lower the watermark in all cases
>>>> where the charge can be lowered, so I'd update the watermark only when
>>>> the fork really happens.
>>>
>>> I don't think that would make a noticeable difference.  That's where
>>> we decide whether to grant fork or not after all and thus where the
>>> actual usage is.
>>
>> I tried using only charge functions, but then the result was too low.
>> With fork callback, the result was as expected.
> 
> Can you please elaborate in more details?

With the example systemd-timesyncd case, I was only getting 1 as the
highwatermark, but there were already two tasks.

-Topi

