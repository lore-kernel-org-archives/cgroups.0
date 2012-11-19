From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Date: Mon, 19 Nov 2012 11:21:42 -0800
Message-ID: <20121119192142.GM15971@htj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VmwrwI4HhGqwGfZFSWAUNMCMI6VHLq3mMnAUGBfjPas=;
        b=ZyBGMKIvCDlIOAimOh5BINie8fHP+fs9TCb4Ag76XajbzjrvpemQj7JnKqhTE8Lwq0
         wSgaLT1yAHjk8Qh/jBbC6JrS9QWMEJAMS4zIrXwBVEvuP3E2gdQ3Zm5PIlXHcBn8+oFr
         JqWVPTfr1ZzpMXdZLzmeJGXWnnUPNX3s6+29aPhlHGqA5S0iC6laN407IKLbhJEf0gKW
         l/mOUtnC4c4mRm5iUSQtcjETAGEIMtC6OVDWfekfXCixFXmn4ZRzmiQWAEGEpXYVYMi3
         SOrncooG0Vv0yXANyivywG3J0t1xsAXiJJm5Uh3lJmtdKcn7Tkxmv07VGKlTKuq2Ilc5
         q1hA==
Content-Disposition: inline
In-Reply-To: <1353123062-23193-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 16, 2012 at 07:30:59PM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> This patchset implements proper hierarchy support for netcls_cgroup.
> Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> single config value instead of array of them.

Applied to cgroup/for-3.8.

Thanks.

-- 
tejun
