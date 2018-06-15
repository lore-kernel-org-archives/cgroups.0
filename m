From: Tejun Heo <tj@kernel.org>
Subject: Re: Cgroups "pids" controller does not update "pids.current" count
 immediately
Date: Fri, 15 Jun 2018 09:16:47 -0700
Message-ID: <20180615161647.GW1351649@devbig577.frc2.facebook.com>
References: <77af3805-e912-2664-f347-e30c0919d0c4@icdsoft.com>
 <20180614150650.GU1351649@devbig577.frc2.facebook.com>
 <7860105c-553a-534b-57fc-222d931cb972@icdsoft.com>
 <20180615154140.GV1351649@devbig577.frc2.facebook.com>
 <1d635d1d-6152-ecfc-d235-147ff1fe7c95@icdsoft.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tdG+trXG1kBx0hQ2bKXsm97k/QxWxuelgCi5+5yuNbg=;
        b=uk3T+5Zo01OuIBCBK54GXfb7cf7pfBirnRuq/d5d9/YViODiY0IaiN4KQRR588NDxm
         ykd102eWbaFpaTlVPEUTn87PHNz0wkI4tbWraD0Lz6mcnSGQm1cLf06afTGpjBcGlka9
         HMK746pB6pmokdhuMRFMPHfWFLDquxrf8lBVWeXt3AEdd4s+Qx/EImdwKKiCQl1MH3ja
         Ch/dq+jqgYNksqHYQefgQi8/yShhx6DXy/deRVJUf8rsnD818gyQxbFc1hzd/wkUVVil
         kXcaJL4zIFM5hjbVX1/Nhoy0zDbb40PRYxvcKG3nPRYMoMYPg/Y3AmDE/kUlCBlvbjfT
         3tBg==
Content-Disposition: inline
In-Reply-To: <1d635d1d-6152-ecfc-d235-147ff1fe7c95@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Zahariev <famzah@icdsoft.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 15, 2018 at 07:07:27PM +0300, Ivan Zahariev wrote:
> I understand all concerns and design decisions. However, having
> RLIMIT_NPROC support combined with "cgroups" hierarchy would be very
> handy.
> 
> Does it make sense that you introduce "nproc.current" and
> "nproc.max" metrics which work in the same atomic, real-time way
> like RLIMIT_NPROC? Or make this in a new "nproc" controller?

I'm skeptical for two reasons.

1. That doesn't sound much like a resource control problem but more of
   a policy enforcement problem.

2. and it's difficult to see why such policies would need to be that
   strict.  Where is the requirement coming from?

Thanks.

-- 
tejun
