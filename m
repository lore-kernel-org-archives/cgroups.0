From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] selftests: cgroup: Add 'malloc' failures checks in
 test_memcontrol
Date: Mon, 27 Feb 2023 15:11:54 +0800
Message-ID: <8C12D50C-97D1-4969-9D02-290B1AB56C72@linux.dev>
References: <20230226131634.34366-1-ivan.orlov0322@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677481955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xXaaQom8mDHJA5re/wVR2Gr6jNo+6nCEO59AZkZGfY=;
        b=YQ6T55nPIluDWjA7F/ABkTa/hvIEyIITBMl+BYge7MKBXtpPjKeaav/yH/nyegFcAdy1It
        Njw5j2fbdlxlq/cXhYoUb6O0hC8CRlTkWhaaKQwD3Qldsn3IU74l56Dc42xKPH5siSALBo
        2S931t/mSsJcW/99YGX8WnYZ4Mh+cPw=
In-Reply-To: <20230226131634.34366-1-ivan.orlov0322@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, lizefan.x@bytedance.com, shuah@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org



> On Feb 26, 2023, at 21:16, Ivan Orlov <ivan.orlov0322@gmail.com> wrote:
> 
> There are several 'malloc' calls in test_memcontrol, which can be
> unsuccessful. This patch will add 'malloc' failures checking to
> give more details about test's fail reasons and avoid possible
> undefined behavior during the future null dereference (like the
> one in alloc_anon_50M_check_swap function).
> 
> Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.

