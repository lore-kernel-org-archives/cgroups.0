From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/3] cgroup: Implement cgroup2 basic CPU usage
 accounting
Date: Tue, 29 Aug 2017 11:10:04 -0700
Message-ID: <20170829181004.GV491396@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170829174325.GS491396@devbig577.frc2.facebook.com>
 <73f65285-867d-8ec0-d81a-000a2d16f611@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=adoDBIt2h8uzASMOn7wXDWtNEd3V2DOhcYoksutXUEU=;
        b=BBNpgBhz1l+RZfxjUS3ZRIKid1iD25vgt55lsDDH1hBsgY9i/eqICUbFWN0rgLI+pD
         //8RiwU0iFGRStwlqCV4Vsu+lIkIGA/ID3qh6tW5Z38tcTPwok1G2yyjXtG64DJAzmfy
         UGLn/BdTIbJHkbOlDkimjgtZtItq7mk/GnhNdAYhys0stXstsgzhW1MK3Ck0rzIWzF5x
         NYb/k15V/DLOhivm8N7t0kXN+2eeB8fvQnaFhRzWipNO/i8bhGes4aa9x6koVPqSVMIk
         ODEpeUPsaVctWDnC9qFCSeJn9IDcrNEa5Rs5Qpcn8UHkyh6XGQJaUzN+iR6AbF9JD43a
         pOrg==
Content-Disposition: inline
In-Reply-To: <73f65285-867d-8ec0-d81a-000a2d16f611@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Tue, Aug 29, 2017 at 02:06:24PM -0400, Waiman Long wrote:
> > Cc: Waiman Long <waiman.long@hpe.com>
> 
> I just noticed that you have used my obsoleted email address in the cc
> line. Would you mind changing it to the one that I am currently using?

Ah, my apologies.  Will update.

Thanks.

-- 
tejun
