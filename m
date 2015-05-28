From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 5/8] cgroup: move enum cgroup_subsys_id definition
Date: Thu, 28 May 2015 16:44:43 -0400
Message-ID: <20150528204443.GC27479@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-6-git-send-email-cyphar@cyphar.com>
 <20150518215944.GK24861@htj.duckdns.org>
 <CAOviyag9Vu=MJcgc7zinXfabyuz2DsOReTUyd-XXd6X8+6CKng@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Q+csJ6/L0daXGvnAxyoJXGJWyedfyPIBYu+tOifuNqA=;
        b=y+jXjvK3TqfeZ+z58xpWhQBp6AjvfHxnyKeMVrFAWxnZiwpsn6LNtBvbZ8Jgd4+oMI
         UPM7U10cayUe3zaPybGYn0YESI/3Nc0j2v4B3k102puQQgo8Xx3sP2G92IMwVjnvNmAb
         kyMy0BY359u3PesNobXPuK9XsESCjc/D0Y2UdQ4pUoEQDXpznGdXtrrEGZ4Kknf5YDBu
         2wTj4IP5znkywF14qdzlvMSdV+g0SvI/BX7PBB9lYyyDrHWOCuLoZC4ehVsUn7vxmoBU
         ox/fyxFRx6lFZBnH+rdktMpNJUzlGXtaQ7NbxnPH3T0T7MF4VJHWhhOVQCqnz0tF271e
         fcBA==
Content-Disposition: inline
In-Reply-To: <CAOviyag9Vu=MJcgc7zinXfabyuz2DsOReTUyd-XXd6X8+6CKng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 19, 2015 at 11:25:41AM +1000, Aleksa Sarai wrote:
> Hi Tejun,
> 
> >> This is in preparation for implementing the pids cgroup subsystem. It is
> >> not a functional change and should not change any behavior.
> >>
> >> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
> >
> > I did a big reorg of cgroup.h and split of cgroup-defs.h from it and
> > this patch doesn't seem necessary anymore.
> 
> Is it in your tree?

Yeap, in for-4.2 branch.

Thanks.

-- 
tejun
