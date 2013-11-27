From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 17:49:03 -0800
Message-ID: <CAO_RewY0eFTgkVqbRJwdW9bgR3nz9h5t6c823wFH5cg1CD0sEA@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com> <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
 <20131126054718.GA19134@mail.hallyn.com> <CAO_RewZ8cUn-PdXfQF0yH=V=9UqE7Yo1JX2pt2c71WYDrpYE0Q@mail.gmail.com>
 <20131126205819.GA27266@mail.hallyn.com> <CAO_RewZh+dNkUdZdu-R3CKTvYzbPL50v-BsBHvek75ti3V6kZQ@mail.gmail.com>
 <20131126212814.GA27602@mail.hallyn.com> <CAD=mX8uuAeN7s8ZA6Gc-wsBd6-PHevBRyBL6hMAS9VW15T5eYA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=3XyGPVJIIlVQyWuiJJklHnw/CXvCIrwXdhyTlwQB9WE=;
        b=KBmBpn/elcA+RAlvpMsL1ib2lI0/kjeAexrSbcJVbKbEQ4jUJWgAvuzT2StIk4aDFI
         Ch0slPnUodDs5gykOQWjnATvfGXT+x9RqPE2jcFomJS1keQk8n3JUlXhF9e4Csv3nrRq
         q/ohwRDHc3z/OU53r9rpdOEAr8ZE1Ugu5RMyHUl5mvmewPNlMk9Y5nnWDqIqUN9eGF2h
         N/Pc3Stg6+fE2rhd4KLgGcP3FQWQCzWHx0IS/JtTWjDnwIvkfKU2CBWBmBF6ua0X/FZ9
         xcxEegbnBCuwvoB3BJGTTBwxO2hR5xn0fC5YyC0zvYonTkuj/P5yjlFxKKN03jhSGlo5
         LBxQ==
In-Reply-To: <CAD=mX8uuAeN7s8ZA6Gc-wsBd6-PHevBRyBL6hMAS9VW15T5eYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

I see three models:

1) Don't "virtualize" the cgroup path.  This is what lmctfy does,
though we have discussed changing to:

2) Virtualize to an "administrative root" - I get to tell you where
your root is, and you can't see anythign higher than that.

3) Virtualize to CWD root - you can never go up, just down.


#1 seems easy, but exposes a lot.  #3 is restrictive and fairly easy -
could we live with that?  #2 seems ideal, but it's not clear to me how
to actually implement it.

On Tue, Nov 26, 2013 at 1:31 PM, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I think most of our usecases have only wanted to know about the parent, but
> I can see people wanting to go further. Would it be much different to
> support both? I feel like it'll be simpler to support all if we go that
> route.
>
>
> On Tue, Nov 26, 2013 at 1:28 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>> > lmctfy literally supports ".." as a container name :)
>>
>> So is ../.. ever used, or does noone every do anything beyond ..?
>
>
