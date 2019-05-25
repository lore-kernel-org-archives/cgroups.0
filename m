From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v2 1/3] kselftest/cgroup: fix unexpected testing failure
 on test_memcontrol
Date: Fri, 24 May 2019 18:06:39 -0600
Message-ID: <ea5514c1-80a1-3c41-de1c-43582b6f1a49@kernel.org>
References: <20190520030140.203605-1-alex.shi@linux.alibaba.com>
 <20190520030140.203605-2-alex.shi@linux.alibaba.com>
 <20190524214035.GG374014@devbig004.ftw2.facebook.com>
 <0c6b76b8-e20c-33f0-21da-64a5d5da30a9@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558742800;
        bh=R5AKhhljVFaewfHEJrRuX+cMSqD/1Iy0pRTZaZD5wOA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gCiElU+nd/lFG9ym/Rld6sfSG6dgF4ypBbDXnsWuBOAJPxmOH5Ruw1x0wSNYyzIkd
         gqUvYt2Y1Hy9DiuXT88sEqhkTCfDgtxngUDv7/Zax9v7o/YFOOvrbPtp66lSut0EWI
         t6IPvgPj2T76F4J4cGrkn+8xspQXslqqsQa5l2hI=
In-Reply-To: <0c6b76b8-e20c-33f0-21da-64a5d5da30a9@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Jay Kamat <jgkamat@fb.com>, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, shuah <shuah@kernel.org>

On 5/24/19 3:44 PM, shuah wrote:
> On 5/24/19 3:40 PM, Tejun Heo wrote:
>> Hello,
>>
>> All three patches look good to me.  Please feel free to add my
>> acked-by.  Shuah, should I route these through cgroup tree or would
>> the kselftest tree be a better fit?
>>
>> Thanks.
>>
> 
> 
> Tejun, I can take them through kselftest tree.
> 

Alex,

patches 1/3 and 2/3 failed checkpatch. Could you please the warns
and send v3. Go ahead and send all v3 for all 3 patches

thanks,
-- Shuah

