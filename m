From: JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
Date: Sat, 23 Feb 2013 08:20:15 +0900
Message-ID: <CAAmzW4OG6b+7t2S3PUY710CDHkbSb9BWxzxWULm5EzJP4BGEXA@mail.gmail.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
	<alpine.DEB.2.02.1302221034380.7600@gentwo.org>
	<alpine.DEB.2.02.1302221057430.7600@gentwo.org>
	<0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
	<5127A607.3040603@parallels.com>
	<0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=X+iKnBwUXJKZYQ9FATuBA3U1HrWn+kkg9tViYed1knA=;
        b=ExtAjn5UwO7F85bEHQYm5C6HRtyM590FBUWfHOIl2GPL1euPUS8VOymyA9AIEfqIyg
         BBk8CQ+4ExZ1F+KRzKRAADlRKn4H/du/nUzgQajdLDByRcHMoggYcgxCPniD5/wKSsmB
         iVl4AOfY50sQAL/Yfd9QWE/StqDVpHbM2xzacPJEzl/YPtuzGa3F84MfYdkM/aiGUKlG
         RQ7evU4sYAcMHtCUr12LtHygdCUzgNGJLT0zGkfTBU+LD21f68MvI+JRFZtm93JDox+n
         x+OUIj4YVi53VBL6+JmgXhSlqDRZxFaDLP6bVPm9qA6LewuUuIBdeqmjvRHpdI7UdCr5
         a7Kw==
In-Reply-To: <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>

2013/2/23 Christoph Lameter <cl@linux.com>:
> On Fri, 22 Feb 2013, Glauber Costa wrote:
>
>> On 02/22/2013 09:01 PM, Christoph Lameter wrote:
>> > Argh. This one was the final version:
>> >
>> > https://patchwork.kernel.org/patch/2009521/
>> >
>>
>> It seems it would work. It is all the same to me.
>> Which one do you prefer?
>
> Flushing seems to be simpler and less code.
>

Hello, Christoph, Glauber.

With flushing, deactivate_slab() occur and it has some overhead to
deactivate objects.
If my patch properly fix this situation, it is better to use mine
which has no overhead.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
