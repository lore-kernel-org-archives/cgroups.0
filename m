From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 2/2] cgroups: add a pids subsystem
Date: Thu, 5 Mar 2015 19:39:39 +1100
Message-ID: <CAOviyaigvfM52GHC4mh8exC+vmj2kffrag4L0TmNz3xjtoc8Ng@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<1425500599-21676-1-git-send-email-cyphar@cyphar.com>
	<1425500599-21676-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425500599-21676-3-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

> +       depends on PAGE_COUNTER
Whoops. I forgot to remove this line. Should I submit a revised
patchset or can you just change the patch?

--
Aleksa Sarai (cyphar)
www.cyphar.com
