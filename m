From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add opts release function to simplify the code
Date: Fri, 11 Mar 2016 12:26:17 -0500
Message-ID: <20160311172617.GE24046@htj.duckdns.org>
References: <1457680035-26772-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dt/JvU23YorEgnHqRqslhrn0pnwKRXpbxybFAPmYBVw=;
        b=guvvV0hntXzh7CEnL4+xk54j5Mijs2oTNJN9vEAnlpY+cINbEErEd3NXD0nKUFj/IG
         RbsxfdqE6D6QtUF+dWN7TDfU5Mf9r3srpSIrd3PkuDh7VdZ69pzAMLSG2gxKz2bc7cZT
         iA1cG7bS448yrI+voSzjdxAN6f1BohgjErUWGP9LhH1dy7eieJ3eSk3ihtHBykfRexyG
         Ji66fn0iT4XUqj9a3XssrrbjdKs9qLE8HszSW2Ip6v3OogWBS6FUqKJDG65bWEAlVZSS
         BGonk9odNbLrp1lQtq4vihW7vKnVpM+4cJ0FgHJClZIwGB4AmPI2zgRxgtm0OuLgZEPi
         79+Q==
Content-Disposition: inline
In-Reply-To: <1457680035-26772-1-git-send-email-lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 11, 2016 at 03:07:15PM +0800, Xiubo Li wrote:
> The old code is a bit confusing for the readers by thinking why
> these two members of opts should be released?
> 
> The resources allocated by whom has the possiblity to release it,
> But this will make the opts parse function more complex. So add
> opts release function to simplify the code, and at the same time
> to make the code more easy to read and be understood.

I'm not really sure this improves anything.

Thanks.

-- 
tejun
