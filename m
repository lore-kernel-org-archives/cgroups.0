From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Defer checking wildcard exceptions to parent
Date: Mon, 19 Dec 2022 07:21:49 -1000
Message-ID: <Y6CdrYdbiBnUSxQi@slm.duckdns.org>
References: <20221219114052.1582992-1-nikolay.borisov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eSN/Hlv/5HI+5br/xw+yoZ8A3PY4ltv42IV6oSp+bf4=;
        b=GU3Iqx7TE/nIcLU9/rUE+9n0oR0xwjOzb98XevQ/KERqjPTJ9LQClvSxkPYnJaszYx
         0wBPIsZ4KiGyGuf8OFpVI7OCiVDaprpOQrNBIqYk27NgibTsReLANi9P5gtu+Kyeylsq
         oeu1AIovcst6uT1EqIDmFLZtouMnUslUbvhYcfnB8ugjacfkoglICWeKjTrKi6Q2Mp/L
         o6qUGgYK05xLDL9t65FeDh9ZlGMaxQmTz53/scE4MfDDq/1XsFUN0Q23m/f5XKnOfMoa
         wfb1hV5TdfezRUEflgIvTdZ53ndH1zUZmxY8eldsGsCnSLqa8hYOvwMx1KMYBkfXkmak
         /erA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221219114052.1582992-1-nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hello, Nikolay.

On Mon, Dec 19, 2022 at 01:40:50PM +0200, Nikolay Borisov wrote:
> The situation I described is how systemd functions, in particular when setting up
> a devcg for a service it would first disable all devices, then add a bunch of
> well-known characters devices and finally evaluate the respective cgroup-related
> directives in the service file, in particular that's how systemd is being run.

I agree that this would have been the right thing to do in the first place.
That said, the behavior has been like this since the beginning and it's
difficult to rule out there may be users that depend on the current behavior
of a child config being rejected if it contains anything beyond the
parent's.

> Without this series systemd-udevd service ends up in a cgroup whose devices.list
> contains:
>
...
> 
> But its .service file also instructs it to add 'b *:* rwm' and 'c *:* rwm'. The
> parent cg in turn contains:
> 
...
> 
> In this case we'd want wildcard exceptions in the child to match any of the
> exceptions in the parent.

and as your example illustrates users already implemented the needed
semantics on top of the existing interface or moved to cgroup2.

I'm not sure about introducing a behavior change this drastic now when users
would expect stability than anything else.

Thanks.

-- 
tejun
