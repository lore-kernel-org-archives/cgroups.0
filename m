From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Thu, 7 Jan 2016 10:42:18 -0500
Message-ID: <20160107154218.GF29797@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
 <20160105215309.GG5995@mtj.duckdns.org>
 <CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
 <20160106225714.GI3660@htj.duckdns.org>
 <CAG53R5XKpP6YAe8buRrgG=m4_dQK5MjkWtcA7CN-74AJ1SUUyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XgGFFyc8kqVhIpXcMCHumb0dKT4vtbhy9IVMsOpz7uA=;
        b=iN3DMJNdrr95C+mchf2Z99SwcNc7rL67JQa8QfE/hAY/OgPgyCf3UQEy7NAga3ZA/e
         uJyjb/t8z2yFE6u7z8sxxrM7f9VHJ4/cqo2EMso30DPgshzjlAfhkTzalFk6En8HPF/3
         aWqQ9AayXcLkMogWkS9Spq1YVF0nqRFh3e7zK445JVGQGpsCclhamq3GkfJN4BUY/KHJ
         wqTWcjG+n8Uw2YFQ0fAk4QxwvQMyDRo8lIuKrrf1MEXsVlaROsjuOP1IUXdYhUzt1U17
         6xXGf4YIf/sab9jorYPyvpJevApbvTa6GdWngsU0AYTgJW9JZ+/WW/7SAUc1ecJXQvnT
         Vj5Q==
Content-Disposition: inline
In-Reply-To: <CAG53R5XKpP6YAe8buRrgG=m4_dQK5MjkWtcA7CN-74AJ1SUUyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jan 07, 2016 at 05:22:40AM +0530, Parav Pandit wrote:
> I can remove "resource" key word. If just that if something other than
> resource comes up to limit to in future, it will be hard to define at
> that time.

Please remove.  The word doesn't mean anything in this context.

> > Also can't the .max file list
> > the available resources?  Why does it need a separtae list file?
> >
> max file does lists them only after limits are configured for that
> device. Thats when rpool (array of max and usage counts) is allocated.
>
> If user wants to know what all knobs are available, than list file
> exposes them on per device basis without actually mentioning actual
> limit or without allocating rpool arrays.
...
> list file looks like below for two device entries.
> mlx4_0 ah qp mr pd srq flow
> ocrdma0 ah qp mr pd
> 
> max file looks like below.
> mlx4_0 ah=100 qp=40 mr=10 pd=90 srq=10 flow=10

Just always show the settings for all devices in the max file like the
following?

  mlx4_0 ah=max qp=max mr=max pd=max srq=max flow=max
  ocrdma0 ah=max qp=max mr=max pd=max

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
