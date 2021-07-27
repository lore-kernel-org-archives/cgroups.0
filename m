From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v7 09/10] memcg: enable accounting for tty-related objects
Date: Tue, 27 Jul 2021 11:02:31 +0300
Message-ID: <d42bd2a3-74a0-163f-6e3a-ad702f6d2817@virtuozzo.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com>
 <b8baa04f-e789-0321-b39d-07c5696ff755@virtuozzo.com>
 <1eef95fe-6172-796e-edd1-095545da6e74@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=W5ZkylOW4aorWqYoZgdy9OUAHDEpy8dU4QmNRvPVlOs=; b=Yj12nar4kB+x0tcn9
        97g0z8UReUWtZBd8M7TK4t+EblgWkMtLRxzEGpJndlo5lJBaTOwX6Ie72E40Rk0K8jA0cK/uuB36K
        LvHZgC3Qjsg3GnIS9NTYCQTgU7QuHIYd0xtpICYl/ho2irAdnFnf2UYH2M9kP6NIg+CLeRnurfSpY
        =;
In-Reply-To: <1eef95fe-6172-796e-edd1-095545da6e74-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/27/21 9:54 AM, Jiri Slaby wrote:
> On 27. 07. 21, 7:34, Vasily Averin wrote:
>> At each login the user forces the kernel to create a new terminal and
>> allocate up to ~1Kb memory for the tty-related structures.
>>
>> By default it's allowed to create up to 4096 ptys with 1024 reserve for
>> initial mount namespace only and the settings are controlled by host admin.
>>
>> Though this default is not enough for hosters with thousands
>> of containers per node. Host admin can be forced to increase it
>> up to NR_UNIX98_PTY_MAX = 1<<20.
>>
>> By default container is restricted by pty mount_opt.max = 1024,
>> but admin inside container can change it via remount. As a result,
>> one container can consume almost all allowed ptys
>> and allocate up to 1Gb of unaccounted memory.
>>
>> It is not enough per-se to trigger OOM on host, however anyway, it allows
>> to significantly exceed the assigned memcg limit and leads to troubles
>> on the over-committed node.
>>
>> It makes sense to account for them to restrict the host's memory
>> consumption from inside the memcg-limited container.
>>
>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>> ---
>>   drivers/tty/tty_io.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index 26debec..e787f6f 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -1493,7 +1493,7 @@ void tty_save_termios(struct tty_struct *tty)
>>       /* Stash the termios data */
>>       tp = tty->driver->termios[idx];
>>       if (tp == NULL) {
>> -        tp = kmalloc(sizeof(*tp), GFP_KERNEL);
>> +        tp = kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
> 
> termios are not saved for PTYs (TTY_DRIVER_RESET_TERMIOS). Am I missing something?

No, you are right, I've missed this.
Typical terminals inside containers use TTY_DRIVER_RESET_TERMIOS flag and therefore do not save termios.
So its accounting have near-to-zero impact in real life.
I'll prepare fixup to drop GFP_KERNEL_ACCOUNT here.

Thank you very much,
	Vasily Averin

>>           if (tp == NULL)
>>               return;
>>           tty->driver->termios[idx] = tp;
>> @@ -3119,7 +3119,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
>>   {
>>       struct tty_struct *tty;
>>   -    tty = kzalloc(sizeof(*tty), GFP_KERNEL);
>> +    tty = kzalloc(sizeof(*tty), GFP_KERNEL_ACCOUNT);
>>       if (!tty)
>>           return NULL;
>>  
> 
> thanks,

