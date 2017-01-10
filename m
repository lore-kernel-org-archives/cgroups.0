From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add missing cgroup-v2 PID controller
 documentation.
Date: Tue, 10 Jan 2017 12:51:57 -0500
Message-ID: <20170110175157.GA3814@htj.duckdns.org>
References: <BC93EBA9-25A6-4445-8E0A-33DC6778A387@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dt6nFtTdwxKkrEuDlim2hz0TOZ3ITqKWyzZmgPJqfmw=;
        b=cTNtxrAzfcLrDGEZkBxAqv8wtLEf9oFBTE+jHE5jWvD2cGi1ke/Bb5dSntehP/zzzB
         ifQ5suAQWL/JGNG/ccfw7bOSVw7AH+csI3LmrpTWMwD34JMAswLJUPxch4FlGcMPkbHu
         w2SsqRpaqsiipjJaPBflyc6Sid+ycmK3nBekDH79s3R52SGJil8rSTdOuE9c2XlXVcov
         mMJfyYpJrbgKOk4RDqWbWglftb+EzXRk3SvUhMDV870jYNxmUbaNiLOuM61pSeCZqo+i
         0TJd6Ujf5ITdA0ioDq//TmWEqz0Sdw1SC2FINcDp90Ai2WBCU7ZanyfM+OHoXRXC8B/x
         Stew==
Content-Disposition: inline
In-Reply-To: <BC93EBA9-25A6-4445-8E0A-33DC6778A387-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hans Ragas <hansr-b10kYP2dOMg@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 10, 2017 at 05:42:34PM +0000, Hans Ragas wrote:
> 
> Signed-off-by: Hans Ragas <hansr-b10kYP2dOMg@public.gmane.org>

Applied to cgroup/for-4.11 with minor adjustments.

Thanks.

-- 
tejun
