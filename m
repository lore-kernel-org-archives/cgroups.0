From: "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Sun, 15 Aug 2021 07:53:06 +0800
Message-ID: <98864178-cf4d-b86e-81e1-70713a0f1d06@gmail.com>
References: <65869aaad05475797d63b4c3fed4f529febe3c26.1627876014.git.brookxu@tencent.com>
 <YRGumHUfK5sJc4A/@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ieV+NzFBwSkcV+dUMdH1Zwl99MJbYbRKj6zgzR3HYo8=;
        b=fw2wAsjVNzwOXlztdlYhKMmryILu560cBP1n1eH1E7aNbT75pBui01fq4RdxbFfy6O
         4X+hk8Du9XGkpszCNLHSaKIRL85MFDBDOmB6WRixaLMNPxFEmhI+cwExRoiOjkktHPzy
         qKRgf/J15GqAlMmi8/MFo8IPGgj3JCnjLeYCTcRL5gQ1Z9LY04wKApcl0jTRTEoXU3Vp
         L0R2iWJmAgY3BW+sJ3U4F50kIuWE5Odxw2XOdyY5ekowFJV/VCS5CFmTdLnpeQUP1lZ8
         zkkPoBsy6LTuWu6ByZrUMPxsEJmPSBUIiKNkFtPbABERuOFVHpngZ52xDrmn2F0lu4r/
         UDpw==
In-Reply-To: <YRGumHUfK5sJc4A/@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hi Jens:

Should we apply this patch for new and older kernel ?

Thanks.

On 2021/8/10 6:39 AM, Tejun Heo wrote:
> On Mon, Aug 02, 2021 at 11:51:56AM +0800, brookxu wrote:
>> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>>
>> After patch 54efd50 (block: make generic_make_request handle
>> arbitrarily sized bios), the IO through io-throttle may be larger,
>> and these IOs may be further split into more small IOs. However,
>> IOPS throttle does not seem to be aware of this change, which
>> makes the calculation of IOPS of large IOs incomplete, resulting
>> in disk-side IOPS that does not meet expectations. Maybe we should
>> fix this problem.
>>
>> We can reproduce it by set max_sectors_kb of disk to 128, set
>> blkio.write_iops_throttle to 100, run a dd instance inside blkio
>> and use iostat to watch IOPS:
>>
>> dd if=/dev/zero of=/dev/sdb bs=1M count=1000 oflag=direct
>>
>> As a result, without this change the average IOPS is 1995, with
>> this change the IOPS is 98.
>>
>> v3: Optimize the use of atomic variables.
>> v2: Use atomic variables to solve synchronization problems.
>>
>> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>
