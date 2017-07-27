From: Dima Zavin <dmitriyz@waymo.com>
Subject: Re: [PATCH v2] cpuset: fix a deadlock due to incomplete patching of cpusets_enabled()
Date: Thu, 27 Jul 2017 14:41:56 -0700
Message-ID: <CAPz4a6AP_OBSFAf6e-S7C+KwDVJj-CHbs5QHe+jJH_R1_1Gc7w@mail.gmail.com>
References: <alpine.DEB.2.20.1707261158560.9311@nuc-kabylake>
 <20170727164608.12701-1-dmitriyz@waymo.com> <20170727125112.5c200880d7580525e24210e3@linux-foundation.org>
Reply-To: dmitriyz@waymo.com
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waymo.com; s=google;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=QIM+2Hs32AjGb9OR5h9xdNn6UWEWmHZpk0xgEORXHww=;
        b=dUnoxFo5pMaX41ESrOsNHPjGOQfiqWUKxdohm2SNw+FonYCZbBR/Jpov1s+sRWujfT
         xUWXn0q4D43S2XEfLPbF3hhCvbfHl1OGg84y8uX1xGHv2GqDCWTRCCGkw8UtTdPKe25/
         DpxX0KM9a13dDFY8o6f1/GJDgw4HvGaUQeCA0=
In-Reply-To: <20170727125112.5c200880d7580525e24210e3@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christopher Lameter <cl@linux.com>, Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cliff Spradlin <cspradlin@waymo.com>, Mel Gorman <mgorman@techsingularity.net>

On Thu, Jul 27, 2017 at 12:51 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 27 Jul 2017 09:46:08 -0700 Dima Zavin <dmitriyz@waymo.com> wrote:
>
>>  - Applied on top of v4.12 since one of the callers in page_alloc.c changed.
>>    Still only tested on v4.9.36 and compile tested against v4.12.
>
> That's a problem - this doesn't come close to applying on current
> mainline.  I can fix that I guess, but the result should be tested
> well.
>

I'll fix up for latest, and see if I can test it. I should be able to
boot vanilla with not too much trouble. May take a few days.
