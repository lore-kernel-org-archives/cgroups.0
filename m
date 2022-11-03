From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: Re: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Thu, 3 Nov 2022 22:55:19 +0800
Message-ID: <830cdb70-2823-9c46-1986-2801023353d0@shopee.com>
References: <20221020074701.84326-1-haifeng.xu@shopee.com>
 <20221027080558.GA23269@blackbody.suse.cz>
 <adb7418c-39a2-6202-970a-a039ad8201dd@shopee.com>
 <20221031131140.GC27841@blackbody.suse.cz>
 <25f6a188-4cc6-dace-1468-fd5645711515@shopee.com>
 <Y2MoBeJGU1Exg6cX@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DDZXj8GxjjLzzwnzzLDMimDqIgBJg1GXsbBMV5BLFZk=;
        b=DAX5Ib72zbcXbDQV1g+lVn1hDwjULe0CH9/YMVCG1hQbvZjWdFqaHBOR0N7iB3YYqj
         /JgecYOLDCYGoENGa9cUPmL5ou3S/ybeaekN4mZv5f9hhUOKFBRFkFAvyTOmrYif+bFE
         m2ABXFYvyZBQkqYgwz/xXvIgElZGBdYa14IBZcrTMor/6XYL8IYvIJK7zmJ2Pt34B+Al
         bVtx/CJB07Yq/6fZd5EQ+V7V3pkiyCyoVsLrpjMouY/ZfUtGUuFm/H6Yp1FlwCAjJ5Ol
         5nlZKi5QTxRFkmHrirau/2KGnIf+pTmWTgIZayuIeVehSKS2D2LLLR/PoUSS78PmWEUT
         BQ3g==
In-Reply-To: <Y2MoBeJGU1Exg6cX@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



On 2022/11/3 10:31, Tejun Heo wrote:
> On Thu, Nov 03, 2022 at 10:13:22AM +0800, Haifeng Xu wrote:
>> I understand your worries. Can I just check the populated state of
>> css_set in 'css_set_update_populated' and don't change the order any
>> more? I think it can also streamline 'css_set_move_task' a bit.
> 
> FWIW, I don't see much value in the proposed change. The resulting code
> isn't better in any noticeable way. Even if the change were straightforward,
> the value of the patch would seem questionable. There's no point in creating
> code churns like this. Nothing is improved in any material way while
> creating completely unnecessary risk for subtle breakages.
> 
> Thanks.
> 
Got it, thanks.
