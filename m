From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v16 05/22] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Thu, 16 Jul 2020 16:17:06 +0300
Message-ID: <20200716131706.h6c5nob4somfmegp@box>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-6-git-send-email-alex.shi@linux.alibaba.com>
 <924c187c-d4cb-4458-9a71-63f79e0a66c8@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W5qvqp7i9pGe/AtHlHz71cVG+5e0FG1RqQpp4GXhoLM=;
        b=sIftRPRG702Z1I1WOW4Fzuf+q99t3ZflmLuikxRMy5BxwR0rtDQ16lcc/wpZ3zaPfU
         yMdgtl4RwI8M0PSkF3LcuQvwavEbpcbx4TUOBXfMTe+wfyULYrlrepSZYODe7HQCfki7
         JbsA+W57eVgW34ZS6t67KVCbO6UxCDukJgodJ6CyglTzJIaewo9slKd8E+Nuj77eawRf
         8qUFkBsvMta/7L/HGyaqYYJdtijGwphH7Kqv/JfBrPMD+SepIiIpalUXgHKSfeUlpin9
         iPvn53qhRGm9DxvI8JvUml+5VbKPW+xUIaebJjYUXWjBaGPieygJ1q6h4gSUihCKtLgl
         d2ZA==
Content-Disposition: inline
In-Reply-To: <924c187c-d4cb-4458-9a71-63f79e0a66c8-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Jul 16, 2020 at 04:59:48PM +0800, Alex Shi wrote:
> Hi Kirill & Matthew,
> 
> Is there any concern from for the THP involved patches?

It is mechanical move. I don't see a problem.

-- 
 Kirill A. Shutemov
