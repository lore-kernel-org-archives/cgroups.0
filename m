From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Mon, 09 Mar 2015 14:58:11 -0400
Message-ID: <54FDED43.4050908@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com> <1425606357-6337-1-git-send-email-cyphar@cyphar.com> <1425606357-6337-3-git-send-email-cyphar@cyphar.com> <20150309033405.GE13283@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=+0YCy1w9TTm1uNuiBF1EeRSMO5UgW/fNDtgJFRkQOWg=;
        b=qKDD1WpQivdDpgzC6Vdv9eR7qcet2FiU3RN9CFLELplAkYpnaPJUC8ZevXFGP2bTPv
         H4T9bidBOgiPD1NTU++EgFkxfpC3I2sNSt/9yn/W79Mm90t2eDuTBELL7jsI9cW9fKVY
         aaWl4PU+bHye77kHPlUkPSAVQN/1V+nlvVWmyKRX57SPYsXoAtUpVBHgUiTidNVWY0KR
         kIRjAcP23uGu0ya/K2uy+RZnjYgHgQ1/pu4FnExyp7vp3wMJ8jGVyiDqGUw9nxCUW/TI
         vd8Z8INDy5stbl5myGAX+A+F13oa8MYzEFgDZSc4WPBFDOk6r/kXM3atTIQjkn4Iauz5
         4xaQ==
In-Reply-To: <20150309033405.GE13283-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-03-08 23:34, Tejun Heo wrote:
>
> Does pids limit make sense in the root cgroup?
>
I would say it kind of does, although I would just expect it to track 
/proc/sys/kernel/pid_max (either as a read-only value, or as an 
alternative way to set it).
