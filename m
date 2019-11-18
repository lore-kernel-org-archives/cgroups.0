From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] docs: cgroup: mm: Fix spelling of "list"
Date: Mon, 18 Nov 2019 08:00:41 -0800
Message-ID: <20191118160041.GU4163745@devbig004.ftw2.facebook.com>
References: <20191111144438.GA11327@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dGjbHgjF0W1b+dELdkoZ7B3L1JrYsAni92y6q3z5/FE=;
        b=di4C7Z2zvQUq2pHY6TUUzLqSiEt9/bLv1Ph0DwW5GqtMpLNFg1Pktx/z/GnrNHEthd
         Ui8CGj0PhcU8u4+374VwlDbMAlVEvnUbsD5hNRM2/hQsUVWR0BeAf4XYFxKKedLzwW3B
         Xi4bVNSTvow7scHY0aC9DxHafzneE2vwVmMn9HGHgOVY2UoxLWJkbsbMLDVLTUPWn+iN
         d1AT+u/KGWCC9hI/cDDqjKgCQFctMZ1JSgs64xm3v5ZWuMFRYl6Be70fdZ+TQ6WCIRQI
         eU794I2pWW8u7KVfnFIznShljSZTY1ypXMJgeWz2gxRWbreI69oZOTOEGqtpLJUdxuap
         7FyA==
Content-Disposition: inline
In-Reply-To: <20191111144438.GA11327@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Mon, Nov 11, 2019 at 02:44:38PM +0000, Chris Down wrote:
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Applied to cgroup/for-5.5.

Thanks.

-- 
tejun
