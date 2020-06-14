From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] cgroup: Refactor two assignments in
 css_task_iter_next_css_set()
Date: Sun, 14 Jun 2020 11:10:08 -0700
Message-ID: <1592158208.5303.27.camel@HansenPartnership.com>
References: <20200614022833.2641-1-zzuedu2000@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1592158213;
        bh=PGzUuMvpO+6kzpKxkF4YyCGT8UrnacuIwBFLYULnNxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZTx/WKouqrcKstUIGTYH++lQrh1C0vddT233DaDgJcSkoBGuRxjHWqDIv/DCV2FcW
         nmxZCgZRR6oEeitdr/0aMl7UpW1j49vR0+Zg3meoln+8dhpfq3A4cLsfk/NygzMn7C
         HnGpeeSnaN0s4TMWZG+0+02/5SCLxtWvJtDl7X9w=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1592158210;
        bh=PGzUuMvpO+6kzpKxkF4YyCGT8UrnacuIwBFLYULnNxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xYL4fKyr/4K6QtdNcTPoG3uoMbGabnRFHbzYyzXFHR3wXMTTfmYRD96xDZcfODMiZ
         hfE+1jK+tXc3acqPmpkdiIkzYtKkU1746J7RAkLAe3WgsBeWJGBxlnDmFoJpxh0QeN
         LSEibjppD4CsuWup94IIZeRZtJpUGySbDGgoFpf4=
In-Reply-To: <20200614022833.2641-1-zzuedu2000@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: zzuedu2000@163.com, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Markus.Elfring@web.de, songmuchun@bytedance.com, buddy.zhang@aliyun.com

On Sun, 2020-06-14 at 10:28 +0800, zzuedu2000@163.com wrote:
> From: Wei Fenghai <zzuedu2000@163.com>
> 
> Combine two assignments for the variable ‘l’ into one statement.

The problem with this commit message isn't the description, we can all
see what the change does, it's the justification.  Why is there any
reason to do this?  My version of gcc does this as an optimization
anyway, so the patch doesn't change to the binary output and it's
arguable that having two statements instead of one makes the code
marginally more readable.

Regards,

James

