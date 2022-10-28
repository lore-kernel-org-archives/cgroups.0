From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use
 del_timer_shutdown() before freeing timer
Date: Fri, 28 Oct 2022 08:11:50 -0700
Message-ID: <6f04aec5-bbff-6154-a0b1-8ad0aec97ec5@roeck-us.net>
References: <20221027150525.753064657@goodmis.org>
	<20221027150925.819019339@goodmis.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=content-transfer-encoding:in-reply-to:from:references:cc:to
	:content-language:subject:user-agent:mime-version:date:message-id
	:sender:from:to:cc:subject:date:message-id:reply-to;
	bh=cu5lq0+6QCF+BQfiaiaRxPUIRB+CVrNKwv+C5DY2DeE=;
	b=jrBrEVx/TWlLwC/EybmMjgT1gIVbiJljUHbETA5hqF92YxNbERFPM8SLV8vK+xyqHj
	9jS6lbrYopAtUqlTWoxmEhrkvVuOVnKHs18xrfkN3sQdJWGdEM8ayfOV6/rcHN9MyDGS
	idiwJN9NfCM2e8NN2NyJ75qSfH6Jw5L/noLRcBMacXiiXUYWcEoONMWesL4OC1T+SBSX
	zRJEmoAlv5F1PTO0uNPS0M5lwoafv7bkttb/uiMKOTZ5pxkfWBm0uH+r/cEtQLtmdLZy
	0aGvxyZT6rXQbiuz2oOdZEl+0+YjZU9rPHTO3PCCSEnn0aiYzAOnagzZG5lkxCKy6xOI
	2NeA==
Content-Language: en-US
In-Reply-To: <20221027150925.819019339-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

On 10/27/22 08:05, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> 
> Before a timer is freed, del_timer_shutdown() must be called.
> 

I also had to add the following, as you had already suggested.

Just changing blk_sync_queue() was insufficient; I had to add the call from
blk_release_queue() because otherwise blk_sync_queue() was not always called.

Thanks,
Guenter

---
diff --git a/block/blk-core.c b/block/blk-core.c
index 17667159482e..69b1daa2e91a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -227,7 +227,7 @@ const char *blk_status_to_str(blk_status_t status)
   */
  void blk_sync_queue(struct request_queue *q)
  {
-       del_timer_sync(&q->timeout);
+       del_timer_shutdown(&q->timeout);
         cancel_work_sync(&q->timeout_work);
  }
  EXPORT_SYMBOL(blk_sync_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e71b3b43927c..12a1e46536ed 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -769,6 +769,8 @@ static void blk_release_queue(struct kobject *kobj)

         percpu_ref_exit(&q->q_usage_counter);

+       blk_sync_queue(q);
+
         if (q->poll_stat)
                 blk_stat_remove_callback(q, q->poll_cb);
         blk_stat_free_callback(q->poll_cb);
