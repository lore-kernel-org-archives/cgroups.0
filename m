From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 16/23] cgroup: relocate cgroup_advance_iter()
Date: Fri, 2 Aug 2013 15:35:56 -0400
Message-ID: <20130802193556.GB29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-17-git-send-email-tj@kernel.org>
 <51FB26C6.2020100@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KNSUr8aQcLwWehqftuTAcb3jkfY6pnNwXd1dHPS/Ehs=;
        b=rcK3h3xKekh/4aSb0xBxz3R7QnQTLChjOraby61j2MxtizZTZGcE4lZD11oVVL3y3Y
         HafLhldHASIelNWjsjgDPDa+HY4oS0Vi4HkyLqmJHQQIR27cLP2J138Jpfdg4at2kYtX
         hXN4ZhOUitOrIB5PSdz+zbrooLEzpByW8vJ16Ar78gbCOKjpjNUWoksdA9X2NEMCmkga
         Wtd9twRXGJlFyY2XngI9ksMEjDmi1rkCekAyAWQwxpEG6FD2bNXMeaRTzyCbj5fe2W3Q
         tkzn4sx6hcDErdbir8ak3quh1UssB8GUZzPBd9rOkJRVTAiIwM/kCmE4Qd44F1hC9Vpr
         130Q==
Content-Disposition: inline
In-Reply-To: <51FB26C6.2020100-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Li.

On Fri, Aug 02, 2013 at 11:25:58AM +0800, Li Zefan wrote:
> On 2013/8/2 5:49, Tejun Heo wrote:
> > For some reason, cgroup_advance_iter() is standing lonely all away
> > from its iter comrades.  Relocate it.
> > 
> 
> There're some other functions that are in the same situation. Do you
> think it's better to relocate them, or just leave it as it is?

Hmm... I really don't wanna do one huge reorganize-everything patch as
they tend to be difficult to verify and the disturbance to benefit
ration usually isn't that high, but if the respective part of code is
going through changes and thus will be disturbed anyway, I think it
makes sense to reorganize a bit.

Thanks.

-- 
tejun
