From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Tue, 15 Mar 2022 18:33:31 +0100
Message-ID: <20220315173329.GB3780@blackbody.suse.cz>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <20220314164332.GA20424@blackbody.suse.cz>
 <bf2ea0888a9e45d3aafe412f0094cf86@saabgroup.com>
 <20220315103553.GA3780@blackbody.suse.cz>
 <84e5b8652edd47d29597d499f29753d6@saabgroup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647365612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4SCnDXkSTk7b/B3VCA90vLf8UjLiVvHK4RLBoX9cBfI=;
        b=N6uWbM2pvpNvTSV+X9Jc71F4clakLdT6Y46VqAJMCwxztGuq+nFvlfrZMsTW63LSan0ydQ
        1pkfaUpBhmqBGL9hka/eENM1TZQrClRjQ2k/AWZo7Wm9Sx7wLrNHak5YMGgWq9YhkfKsUY
        x3riBzhht+yXsB8jjTXrJqk0dTqZxAA=
Content-Disposition: inline
In-Reply-To: <84e5b8652edd47d29597d499f29753d6-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 15, 2022 at 03:49:52PM +0000, Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org> wrote:
> As you might have already surmised it was a placeholder example to
> give the general idea. I think it is time to add some more details. :)

Thanks for sharing the additional description.

> Assume that you have an embedded system running some kind of software
> with real time like properties. You want to develop and debug your
> software locally on your high-end machine since it is much more
> convenient. Alas the software runs way too fast due to the difference
> in performance so you can't detect overruns etc.

There are certainly more knowledgeable people than me to help with
debugging such environments.

> One way of implementing this kind of scheduler would be to create a
> fork of the FIFO scheduler that have this behavior.

I think you've complete info now how threads are handled with cgroups.

Good luck with the fork :-)


Michal
