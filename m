From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Tue, 26 Nov 2013 12:49:36 -0800
Message-ID: <CAO_Rewax-wfR07OB727924iGHh-qJpAYZf4ZmeCFLxXP40p39Q@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com> <1385432284.8590.52.camel@mtking.wittsend.com>
 <CAO_RewYmS0fH819BFCr9ozis1132dACgCPwbyb59gM1PafpUkw@mail.gmail.com> <20131126163737.GB23834@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=kE+j9VlBLj969McozX12NNCXUIHEF1jf2ZIgKFCWOhQ=;
        b=QB0m/uoTbX5z9kOWNlfxqwi2vWoHW3A0P+rTe8b9CRpKSAlAZSDrS/rTI3SGonU5zd
         pID7zTWtKqS8TVjYXd+1pF9eGO1MJLDKfp4iQWlPiKXS3X1Sqkj+NteRz0eq//YAtIjp
         zp5Fp2swPiyDt2I9LsuUjkrET/z21r19b1S9ZMhZuG4B5HBxbOCiE3Oekx/hkb5O0for
         EnvYMHRc6YQXfD8rRbVhv04Bgeps0R9vysLHq0kU6ttm3PRf0X3m8WXBlop7OPX1NAtk
         uaWqg2PG03SmDlAqkJSM9rYb21JO8KcWWl7SxpN/UBV5bfVFv/op2DCmeQP2dET2wBpU
         FBhA==
In-Reply-To: <20131126163737.GB23834-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: mhw-UGBql2FAF+1Wk0Htik3J/w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

On Tue, Nov 26, 2013 at 8:37 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>> At the start of this discussion, some months ago, we offered to
>> co-devel this with Lennart et al.  They did not seem keen on the idea.
>>
>> If they have an established DBUS protocol spec,
>
> see http://www.freedesktop.org/wiki/Software/systemd/ControlGroupInterface/
> and http://man7.org/linux/man-pages/man5/systemd.cgroup.5.html
>
>>  we should consider
>> adopting it instead of a new one, but we CAN'T just play follow the
>> leader and do whatever they do, change whenever they feel like
>> changing.
>
> Right.  And if we suspect that the APIs will always be at least
> subtly different, then keeping them obviously visually different
> seems to have some benefit.  (i.e.
>         systemctl set-property httpd.service CPUShares=500 MemoryLimit=500M
> vs
>         dbus-send cgmanager set-value http.server "cpushares:500 memorylimit:500M swaplimit:1G"
> ) rather than have admins try to remember "now why did that not work
> here, oh yeah, MemoryLimit over here should be Memorylimit" or whatever.
>
> Then again if lmctfy is the layer which admins will use, then it
> doesn't matter as much.
>
>> It would be best if we could get a common DBUS api specc'ed and all
>> agree to it.  Serge, do you feel up to that?
>
> Not sure what you mean - I'll certainly send the API to these lists as

What I meant was whether it is worth opening a discussion with the
systemd folks on a common lowest-level DBUS interface.  But it looks
like their work is already a bit higher level, so it's probably moot.

> the code is developed, and will accept all feedback that I get.  My only
> requirements are that the requirements I've listed in the document
> be feasible, and be feasible back to, say, 3.2 kernels.  So that is
> why we must send an scm-cred for the pid to move into a cgroup.  (With
> 3.12 we may have alterntives, accepting a vpid as a simple dbus message
> and setns()ing into the requestor's pidns to echo the pid into the
> cgroup.tasks file.)
>
> -serge
