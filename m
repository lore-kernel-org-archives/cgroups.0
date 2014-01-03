From: John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH net-next 1/4] net: introduce backup_classid to struct
	skbuff
Date: Thu, 02 Jan 2014 22:21:38 -0800
Message-ID: <52C656F2.8060803@gmail.com>
References: <52C62A48.1050604@huawei.com>
	<20140103.003404.1439874071277993396.davem@davemloft.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject
	:references:in-reply-to:content-type:content-transfer-encoding;
	bh=HJ5r1AR98xYnsH259kEd/YnHyd/FAISKdj/rzPc9GoE=;
	b=EzpZEBxnltQ5ltXpleRa8TQZz0LLGaD7hlqCt4o7RCy1c2mjskFJnGzeOkODXQc46W
	2E6n2RFqWA3tQfeGsjBpYnX9VEO8j5ey45BuQWjz5GzyIQap0qynsVvb2I9RiZwim1dc
	56NRIxdlYCfssOxmkwUoj8Gkz+KPrUIFw0gev76yMkZzczDJy2fEXvUWMt3FR5ZMuZ2J
	FIayNY6DwPD+C/9jC/E95snOi6jU0V5KcVm7e3HZlPI1haQKadCnBlMesIBViBSl3n9L
	oFNndWLkiGPm7hMf++14Lfey76zwCI5+XY+gFQlYYy8mxRKLy/jRZJLrJBS7FgE3BAjA
	kRrA==
In-Reply-To: <20140103.003404.1439874071277993396.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: clbchenlibo.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 01/02/2014 09:34 PM, David Miller wrote:
> From: Libo Chen <clbchenlibo.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Date: Fri, 3 Jan 2014 11:11:04 +0800
>
>>
>> introduce backup_classid to struct skbuff,
>> we can use it to backup sk_classid when net_ns switch.
>>
>> Signed-off-by: Libo Chen <clbchenlibo.chen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Sorry, no new sk_buff members unless there is absolutely not other
> possible implementation.
>
> sk_buff is too big as-is.

To get what you want fix the dev_forward_skb() call. But its
not clear to me why you would expect the sock info to be propagated
like this. It seems like an incorrect assumption or a misunderstanding
somewhere. If the virtual link was a physical link you wouldn't expect
to know anything about the senders socket.

Thanks,
John

-- 
John Fastabend         Intel Corporation
