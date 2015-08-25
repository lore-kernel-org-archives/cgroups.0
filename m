From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroup: get a ref to source csses when migrating
Date: Tue, 25 Aug 2015 14:14:45 -0400
Message-ID: <20150825181445.GB26785@mtj.duckdns.org>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
 <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
 <1440335432-4202-2-git-send-email-cyphar@cyphar.com>
 <20150824184507.GB28944@mtj.duckdns.org>
 <CAOviyagYytw2t20c4a-GaFJDRArtF67CHFPN127CRpnzr0Y9kA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OrsmBEuYuL68X1EFM9TwlEtU4rsKAtpGWbGJvC1C9+E=;
        b=traZ3pdFkjng8Cz0oR14EyyroL1e9z5A4Gz9CmSrEs88HfTfwXzNdzq2lZCrXn5uGi
         0QFMLO2ge6ngIyQkvJcPdZ6Skg619H2uasiA0q0Z/jLjQB6yxHMG5h9sNNcgPZr8OHDk
         N91c109i5g/BMa0eKJd05pP9ffppf1o2IUkLUXdcdnES6uYlbon69qaHtMuDkMMyglR/
         sA9ThaML9LZ335WsWIq31LsMRCvIYH7nmkK7Zfl1y9ONYqzcrVdF+HREnVhEPxdHVWAH
         mG8NInFtjvEgEWJK5ufjqua6JY0yoHcqCTN6HaNADjC6k/MdDZK8vg3suP7snq866UQ/
         mEjQ==
Content-Disposition: inline
In-Reply-To: <CAOviyagYytw2t20c4a-GaFJDRArtF67CHFPN127CRpnzr0Y9kA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Aleksa.

On Tue, Aug 25, 2015 at 12:00:54PM +1000, Aleksa Sarai wrote:
> You also mentioned that depending on the css_set's ref being bumped to
> protect the contained csses is "sort of implementation detail.  It can
> be implemented in different ways." Which made me think that depending
> on that is not a good idea.
> 
> But if it's safe to depend on the cgroup_migrate_add_src() pinning the
> ref on the css_set, I'll drop this patch and fix up the other one
> accordingly.

Yeah, let's go w/o the explicit refcnting.

Thanks.

-- 
tejun
