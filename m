From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use
 del_timer_shutdown() before freeing timer
Date: Fri, 28 Oct 2022 08:11:27 -0600
Message-ID: <9bb423f8-5910-494d-2522-2fcf8e41c2e4@kernel.dk>
References: <20221027150525.753064657@goodmis.org>
	<20221027150925.819019339@goodmis.org>
	<20221027111944.39b3a80c@gandalf.local.home>
	<Y1uSG/7VXWLNlxlt@infradead.org>
	<20221028062414.7859f787@gandalf.local.home>
	<60b91c39-1e54-ac8b-5e9e-db7e46ca2d60@kernel.dk>
	<20221028100656.00a4d537@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kernel-dk.20210112.gappssmtp.com; s=20210112;
	h=content-transfer-encoding:in-reply-to:from:references:cc:to
	:content-language:subject:user-agent:mime-version:date:message-id
	:from:to:cc:subject:date:message-id:reply-to;
	bh=kGB0yLuP8CITE3oAOA1XPVmKhjSqbWLjvxAfBGLgZKA=;
	b=0z66opcyZ//OUKHR6i+YUV9zNteirxKzVrdMRkn0+t0luxKI9/P6+kH98WqeYPwWOP
	hd3EIXwncilkJxXhLXlKVfmdH2pDo3lfHq+9bFl3L/Kc/f5ySbf/0zXUGnxYQKqSn5El
	ejjYwTczrw7KnUVP+04ANMYgKqO8pZRJMtT5YoeqqiCfsjqk/zJGUGtpb8by4sNTF5g1
	NT7PUPSDk9/l6OlE+zWWbP8fvgQeQ+goVHsVjTR+ImIICz28N+hGiTJy6RntgiPd9AWk
	9zlKeTWllGAXlQRfjBtK+s2XipUhQ5LxhQ2XSpT9TFct6VqvGtZQMeNUFELFPT87uJIX
	lBbA==
Content-Language: en-US
In-Reply-To: <20221028100656.00a4d537-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

On 10/28/22 8:06 AM, Steven Rostedt wrote:
> On Fri, 28 Oct 2022 07:56:50 -0600
> Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> 
>> On 10/28/22 4:24 AM, Steven Rostedt wrote:
>>> On Fri, 28 Oct 2022 01:26:03 -0700
>>> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>>   
>>>> This is just a single patch out of apparently 31, which claims that
>>>> something that doesn't even exist in mainline must be used without any
>>>> explanation.  How do you expect anyone to be able to review it?  
>>>
>>>   https://lore.kernel.org/all/20221027150525.753064657-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org/
>>>
>>> Only the first patch is relevant to you. I guess the Cc list would have
>>> been too big to Cc everyone that was Cc'd in the series.  
>>
>> No it's not, because how on earth would anyone know what the change does
>> if you only see the simple s/name/newname change? The patch is useless
>> by itself.
>>
> 
> I meant this as the first patch:
> 
>   https://lore.kernel.org/all/20221027150925.248421571-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org/
> 
> Which was what the link above was suppose to point to.
> 
> It's the only patch relevant to the rest of the series, as the rest is just
> converting over to the shutdown API, and the last patch changes
> DEBUG_OBJECTS_TIMERS to catch if this was done properly.
> 
> That is, patch 01/31 and the patch you were Cc'd on is relevant, and for
> those that want to look deeper, see patch 31 as well.

So we got half of what was needed to make any kind of sense of judgement
on the patch.

> But if I included the Cc list for patch 01 for all those Cc'd in the
> entire series, it would be a huge Cc list, so I avoided doing so.

And my point is that just CC'ing the relevant list for patch 4/31 is
useless. Do we need to see the whole series? No. Does everyone need to
see patch 1/31? Yes, very much so. Without that, 4/31 means nothing.

This is pretty common for tree wide changes. The relevant lists need
to see the full context, patch 4/31 by itself is useless and may as well
not be sent at this point then.

-- 
Jens Axboe
