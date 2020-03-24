From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] mm, memcg: Add memory.transparent_hugepage_disabled
Date: Tue, 24 Mar 2020 15:17:58 +0300
Message-ID: <20200324121758.paxxthsi2f4hngfa@box>
References: <1585045916-27339-1-git-send-email-teawater@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1SPUCMMR/pnomJcGWLTMgKFX0vHSGUAZoz9GUYMTj4o=;
        b=tilrUvK9V7AIYx6emcjcWpLXFQEyHa+05bdQDIoIywZX2y3SMoEqBFiAybQqeaoQmH
         qCW38SL4fJ5VBAOb8iFlk///0sNWC25UhpYQQWKRgBijygrHu0xvBAtqsphh+EUTl/O2
         G/N7sSiUT0spzki5rmzIRfzFDkF3rhztgtSZFIbBY7oBrWXTwy66j+A3LVnCQDsi7qDk
         /Mt7MYFlctk0gdfk6O3vSL+Tj6CY4O0eXlyiZi2ju9Ktl4TK6O0hsWQBgPzPB8PW2grU
         HFeLO7sow8tEfwRFWJ+cSErDCMq4U85TpHZyFV3YvgQJyUfiAMty/XMOrODGeLxAgSoU
         xXgg==
Content-Disposition: inline
In-Reply-To: <1585045916-27339-1-git-send-email-teawater@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Zhu <teawater@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, hughd@google.com, yang.shi@linux.alibaba.com, dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com, sean.j.christopherson@intel.com, thellstrom@vmware.com, guro@fb.com, shakeelb@google.com, chris@chrisdown.name, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Hui Zhu <teawaterz@linux.alibaba.com>

On Tue, Mar 24, 2020 at 06:31:56PM +0800, Hui Zhu wrote:
> /sys/kernel/mm/transparent_hugepage/enabled is the only interface to
> control if the application can use THP in system level.

No. We have prctl(PR_SET_THP_DISABLE) too.

-- 
 Kirill A. Shutemov
