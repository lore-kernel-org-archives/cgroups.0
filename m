From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 5/8] cgroup: move enum cgroup_subsys_id definition
Date: Mon, 18 May 2015 17:59:44 -0400
Message-ID: <20150518215944.GK24861@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-6-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HjId2RDlNF4cQxCDRGJJvK0+jeIXiDrO1R/CBZa3vYU=;
        b=eUuyzVW3ZugZkjMeZHEVIIEuz5RUtDu8CbBMDtCKW9GbOl/0J9jGEfcMGa55pJvLLl
         pLt4pX7/QA6v9PVpWDMcyUvAheVv1c21xgBpRxTOAExdYftG74hoD8bVLZs57Zms6gZL
         yuO+M4S/+5r4Qx3yuauaO0oq5jaw5QNLSFLsZxO12Q+qdVkqcZpoi0oD7Qfwbmqb5jM3
         WydndeBux0cno4lwTvMvsiWjUdI7UvTN3eWvQcQidADLtV86fMq5XRXT7aCpMwlxQKsm
         11dFPoAZ1lsHRe1aNqgvu7d4GipUUKJBaTrfnScNohL8r/KhbKtpqsTMIfuUSOS4L0SE
         mybg==
Content-Disposition: inline
In-Reply-To: <1431960667-26593-6-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 19, 2015 at 12:51:04AM +1000, Aleksa Sarai wrote:
> This is in preparation for implementing the pids cgroup subsystem. It is
> not a functional change and should not change any behavior.
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

I did a big reorg of cgroup.h and split of cgroup-defs.h from it and
this patch doesn't seem necessary anymore.

Thanks.

-- 
tejun
