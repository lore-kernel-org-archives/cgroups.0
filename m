From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: pids controller fails to track zombie processes
Date: Tue, 6 Oct 2015 05:42:53 +1100
Message-ID: <CAOviyagshZQKzQb1aL4_YYNNKSMXMAGpEi7NPuZmKbhB3AUdFQ@mail.gmail.com>
References: <20151005180919.GC11164@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005180919.GC11164@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Tejun,

> I noticed that the pids controller is uncharging from the task exit
> path; however, this isn't correct as zombie processes can linger on
> way after exit while holding pids.

Maybe try adding a callback on the wait() path and remove the exit()
callbacks for the controller? But I'm not sure if that's safe (can we
even call task_get_css() on a task that's being waited on?).

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
